//
//  ChatViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 01.01.2024.
//

import Combine
import KeyboardNotificationsObserver
import PKHUD
import UIKit

class ChatViewController: UIViewController {
    // MARK: - Types

    typealias UserViewModel = ChatViewModel.UserViewModel
    typealias MessageItem = ChatViewModel.MessageItem
    typealias HeaderItem = ChatDateHeaderView.ViewModel
    typealias DataSource = UITableViewDiffableDataSource<HeaderItem, MessageItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HeaderItem, MessageItem>

    // MARK: - UI Controls

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false

        tableView.register(cellType: ChatMessageTextCell.self)
        tableView.register(cellType: ChatMessageImageCell.self)
        tableView.register(headerFooterViewType: ChatDateHeaderView.self)

        return tableView
    }()

    private let userView: UserView = {
        let view = UserView()
        return view
    }()

    private lazy var chatInputView: ChatInputView = {
        let view = ChatInputView()

        view.didTapAttachment = { [weak self] in
            self?.presentPickerAlert()
        }

        view.didTapSend = { [weak self] text in
            self?.viewModel.sendMessage(text: text)
        }

        return view
    }()

    private var chatInputViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectImageAttachmentType: ((_ provider: ImagePickerProvider) -> Void)?
    var didTapMessageImage: ((_ url: URL) -> Void)?

    // MARK: - Properties

    private let viewModel: ChatViewModel

    private lazy var dataSource = makeDataSource()

    private let keyboardObserver = KeyboardNotificationsObserver()

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        bindViewModelActions()
        viewModel.loadMessages()
    }

    // MARK: - UI Methods

    private func setupUI() {
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = userView

        navigationController?.navigationBar.standardAppearance.backgroundColor = R.color
            .themePrimary()

        view.backgroundColor = R.color.themeBackground()

        view.addSubview(tableView)
        view.addSubview(chatInputView)

        tableView.applyConstraints(
            .top(to: view.safeAreaLayoutGuide, attribute: .top),
            .leading(to: view, attribute: .leading),
            .trailing(to: view, attribute: .trailing)
        )

        chatInputViewBottomConstraint = chatInputView.applyConstraints(
            .top(to: tableView, attribute: .bottom),
            .leading(to: view, attribute: .leading),
            .trailing(to: view, attribute: .trailing),
            .bottom(to: view.safeAreaLayoutGuide, attribute: .bottom)
        ).last!

        keyboardObserver.onWillShow = { [weak self] userInfo in
            guard let self else { return }

            let height = userInfo.endFrame.height - self.view.safeAreaInsets.bottom
            self.animateKeyboardAppearance(constant: height, userInfo: userInfo)
        }

        keyboardObserver.onWillHide = { [weak self] userInfo in
            self?.animateKeyboardAppearance(constant: 0, userInfo: userInfo)
        }
    }

    private func animateKeyboardAppearance(
        constant: CGFloat,
        userInfo: KeyboardNotificationsObserver.UserInfo
    ) {
        chatInputView.layer.removeAllAnimations()

        let curveOptions: UIView.AnimationOptions
        switch userInfo.animationCurve {
        case .easeIn: curveOptions = [.curveEaseIn]
        case .easeOut: curveOptions = [.curveEaseOut]
        case .easeInOut: curveOptions = [.curveEaseInOut]
        case .linear: curveOptions = [.curveLinear]
        @unknown default: curveOptions = []
        }

        UIView.animate(
            withDuration: userInfo.animationDuration,
            delay: .zero,
            options: curveOptions
        ) {
            self.chatInputViewBottomConstraint.constant = -constant
            self.view.layoutIfNeeded()
        }
    }

    private func updateNavbarData(userData: UserViewModel) {
        userView.configure(with: userData)
    }

    private func bindViewModelActions() {
        viewModel.$userViewModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userData in
                self?.updateNavbarData(userData: userData)
            }
            .store(in: &subscriptions)

        viewModel.$messagesUpdatedEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }

                self.reloadData(messages: self.viewModel.messages)
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .receive(on: DispatchQueue.main)
            .sink { error in
                print("Error \(error)")
            }
            .store(in: &subscriptions)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // isLoading ? HUD.show(.progress) : HUD.hide()
            }
            .store(in: &subscriptions)

        viewModel.$isSendingMessageEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSendingMessage in
                self?.chatInputView.setLoading(isSendingMessage)
            }
            .store(in: &subscriptions)

        viewModel.$messageSentEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.chatInputView.clearInput()
            }
            .store(in: &subscriptions)
    }

    private func reloadData(messages: [(HeaderItem, [MessageItem])]) {
        var snapshot = Snapshot()

        let headers = messages.map { $0.0 }

        guard !headers.isEmpty else { return }

        snapshot.appendSections(headers)
        messages.forEach {
            snapshot.appendItems($0.1, toSection: $0.0)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .text(model):
                let cell = tableView.dequeueReusableCell(
                    for: indexPath,
                    cellType: ChatMessageTextCell.self
                )
                cell.configure(with: model)
                return cell

            case let .image(model):
                let cell = tableView.dequeueReusableCell(
                    for: indexPath,
                    cellType: ChatMessageImageCell.self
                )
                cell.configure(with: model)

                cell.didTapImage = { [weak self] in
                    guard let url = URL(string: model.url) else { return }

                    self?.didTapMessageImage?(url)
                }

                return cell
            }
        }
    }

    private func presentPickerAlert() {
        let sheet = UIAlertController(
            title: Strings.chatChatMessagesPhotoPickerTitle(),
            message: Strings.photoPickerLimitDisclaimer(),
            preferredStyle: .actionSheet
        )

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(
                .init(
                    title: Strings.photoPickerPhotoText(),
                    style: .default
                ) { [weak self] _ in
                    guard let self = self else { return }
                    self.didSelectImageAttachmentType?(
                        self.viewModel.imageActionProvider(for: .camera)
                    )
                }
            )
        }

        sheet.addAction(
            .init(
                title: Strings.photoPickerGalleryText(),
                style: .default
            ) { [weak self] _ in
                guard let self = self else { return }
                self.didSelectImageAttachmentType?(self.viewModel.imageActionProvider(for: .photos))
            }
        )

        sheet.addAction(.init(title: Strings.photoPickerCancel(), style: .cancel))

        present(sheet, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(ChatDateHeaderView.self),
              let model = viewModel.messages[safe: section]?.0
        else {
            return nil
        }

        view.configure(with: model)

        return view
    }
}
