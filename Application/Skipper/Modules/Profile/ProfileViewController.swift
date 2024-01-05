//
//  ProfileViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Combine
import Foundation
import PKHUD
import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Definitions

    typealias Option = ProfileViewModel.Option

    // MARK: - UI Controls

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    private lazy var headerView: ProfileHeaderView = {
        let view = ProfileHeaderView()

        view.didTapEditAvatar = { [weak self] in
            self?.showAvatarOptionsSheet()
        }

        return view
    }()

    private lazy var logoutButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        return button
    }()

    private lazy var deleteAccountButton: UIButton = {
        let button = DangerSecondaryButton()
        button.setTitle("Удалить аккаунт", for: .normal)
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0
        return button
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapEditProfileInfo: (() -> Void)?
    var didTapEditPassword: (() -> Void)?
    var didTapEditNotifications: (() -> Void)?
    var didTapLessonsManagement: (() -> Void)?
    var didTapImageAction: ((ImagePickerProvider) -> Void)?

    // MARK: - Properties

    private let viewModel: ProfileViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ProfileViewModel) {
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadData()
    }

    // MARK: - UI Methods

    private func setupUI() {
        title = "Мой профиль"
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = R.color.themeBackground()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(stackView)
        contentView.addSubview(logoutButton)
        contentView.addSubview(deleteAccountButton)

        scrollView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))
        contentView.applyConstraints(
            .fit(in: scrollView.contentLayoutGuide),
            .width(to: scrollView, attribute: .width)
        )

        headerView.applyConstraints(
            .top(to: contentView, attribute: .top),
            .leading(to: contentView, attribute: .leading),
            .trailing(to: contentView, attribute: .trailing)
        )

        stackView.applyConstraints(
            .top(to: headerView, attribute: .bottom, constant: 16),
            .leading(to: contentView, attribute: .leading),
            .trailing(to: contentView, attribute: .trailing)
        )

        logoutButton.applyConstraints(
            .top(to: stackView, attribute: .bottom, constant: 32),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .height(constant: 45)
        )

        deleteAccountButton.applyConstraints(
            .top(to: logoutButton, attribute: .bottom, constant: 8),
            .leading(to: contentView, attribute: .leading, constant: 16),
            .trailing(to: contentView, attribute: .trailing, constant: -16),
            .bottom(to: contentView, attribute: .bottom, constant: -8),
            .height(constant: 45)
        )

        setupStackView(with: viewModel.options)
    }

    private func setupStackView(with options: [Option]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        options
            .map(makeOptionView)
            .forEach {
                stackView.addArrangedSubview($0)
                stackView.addArrangedSubview(makeSeparator())
            }
    }

    private func bindViewModelActions() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(
                    "Ошибка",
                    message: error.localizedDescription,
                    controller: self
                )
            }
            .store(in: &subscriptions)

        viewModel.$profileInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                self?.headerView.configure(
                    with: .init(
                        avatarUrl: info.avatarUrl,
                        name: info.name,
                        email: info.email
                    )
                )
            }
            .store(in: &subscriptions)

        viewModel.$options
            .receive(on: DispatchQueue.main)
            .sink { [weak self] options in
                self?.setupStackView(with: options)
            }
            .store(in: &subscriptions)
    }

    private func showAvatarOptionsSheet() {
        let sheet = UIAlertController(
            title: "Update Avatar",
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
                    self.didTapImageAction?(self.viewModel.imageActionProvider(for: .camera))
                }
            )
        }

        sheet.addAction(
            .init(
                title: Strings.photoPickerGalleryText(),
                style: .default
            ) { [weak self] _ in
                guard let self = self else { return }
                self.didTapImageAction?(self.viewModel.imageActionProvider(for: .photos))
            }
        )

        sheet.addAction(.init(title: Strings.photoPickerCancel(), style: .cancel))

        present(sheet, animated: true)
    }

    // MARK: - UI Builders

    private func makeOptionView(for option: Option) -> ProfileOptionView {
        let view = ProfileOptionView()

        view.configureWith(title: option.title, image: option.icon)

        view.addAction(
            .init { [weak self, weak view] _ in
                view?.performBlink()

                switch option {
                case .info: self?.didTapEditProfileInfo?()
                case .password: self?.didTapEditPassword?()
                case .notifications: self?.didTapEditNotifications?()
                case .lessons: self?.didTapLessonsManagement?()
                }
            },
            for: .touchUpInside
        )

        return view
    }

    private func makeSeparator() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let view = UIView()
        view.backgroundColor = R.color.primary06()

        container.addSubview(view)

        view.applyConstraints(
            .fitWithInsets(in: container, insets: .init(top: 0, left: 16, bottom: 0, right: 0)),
            .height(constant: 1)
        )

        return container
    }

    // MARK: - UI Callbacks

    @objc private func logoutAction() {
        viewModel.logout()
    }

    @objc private func deleteAction() {
        viewModel.deleteAccount()
    }
}
