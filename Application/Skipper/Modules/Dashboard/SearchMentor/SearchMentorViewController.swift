//
//  SearchMentorViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2023.
//

import Combine
import Foundation
import UIKit

class SearchMentorViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        tableView.register(cellType: SearchMentorCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController()

        controller.searchBar.placeholder = Strings.searchMentorSearchPlaceholder()
        controller.searchBar.tintColor = R.color.primary87()
        controller.searchBar.searchTextField.backgroundColor = R.color.themePrimary()

        controller.obscuresBackgroundDuringPresentation = false

        controller.searchResultsUpdater = self

        return controller
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectMentor: ((_ mentorId: String) -> Void)?

    // MARK: - Properties

    private let viewModel: SearchMentorViewModel

    private var subscription: AnyCancellable?

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: SearchMentorViewModel) {
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

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()

        title = Strings.searchMentorNavTitle()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        view.addSubview(tableView)
        tableView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))
    }

    private func bindViewModelActions() {
        subscription?.cancel()
        subscription = viewModel.$itemsUpdatedEvent
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchMentorViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchMentorCell = tableView.dequeueReusableCell(for: indexPath)

        let item = viewModel.items[indexPath.row]

        cell.configureWith(name: item.name,
                           major: item.major,
                           rating: item.rating,
                           imageURL: item.imageURL,
                           description: item.description,
                           subcategories: item.subcategories,
                           layoutWidth: tableView.frame.width)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as? SearchMentorCell
        cell?.performBlink()

        didSelectMentor?(viewModel.items[indexPath.row].id)
    }
}

// MARK: - UISearchControllerDelegate

extension SearchMentorViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text ?? ""

        viewModel.applySearchText(searchQuery)
    }
}
