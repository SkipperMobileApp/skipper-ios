//
//  ChatsListViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.12.2023.
//

import Combine
import UIKit

class ChatsListViewController: UIViewController {
    // MARK: - Types

    typealias ChatItem = ChatListCell.ViewModel
    typealias DataSource = UITableViewDiffableDataSource<Int, ChatItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ChatItem>

    // MARK: - UI Controls

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.delegate = self

        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()

        tableView.register(cellType: ChatListCell.self)

        return tableView
    }()

    private lazy var dataSource = makeDataSource()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectChat: ((_ chatId: String, _ opponentId: String) -> Void)?

    // MARK: - Properties

    private let viewModel: ChatsListViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ChatsListViewModel) {
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

        setNavigationBarAppearance(isTranslucent: true)

        viewModel.subscribeOnChats()
    }

    // MARK: - UI Methods

    private func setNavigationBarAppearance(isTranslucent: Bool) {
        var barAppearance = UIBarAppearance()
        if isTranslucent {
            barAppearance.configureWithTransparentBackground()
        } else {
            barAppearance.configureWithDefaultBackground()
            barAppearance.backgroundColor = R.color.themePrimary()
        }

        let appearance = UINavigationBarAppearance(barAppearance: barAppearance)

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }

    private func setupUI() {
        title = "Чаты"
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = R.color.themeBackground()

        view.addSubview(tableView)
        tableView.applyConstraints(
            .fit(in: view)
        )
    }

    private func bindViewModelActions() {
        viewModel.$chats
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chats in
                self?.reloadData(chats: chats)
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
            }
            .store(in: &subscriptions)
    }

    private func reloadData(chats: [ChatItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(chats, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChatListCell.self)
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ChatsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let chatId = viewModel.chats[indexPath.row].id
        let opponentId = viewModel.chats[indexPath.row].opponentId

        didSelectChat?(chatId, opponentId)
    }
}
