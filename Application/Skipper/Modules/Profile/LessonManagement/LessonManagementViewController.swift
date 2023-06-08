//
//  LessonManagementViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.04.2023.
//

import Combine
import Foundation
import PKHUD
import UIKit

class LessonManagementViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        tableView.register(cellType: LessonManagementCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController()

        controller.searchBar.placeholder = Strings.lessonManagementSearchBarPlaceholder()
        controller.searchBar.tintColor = R.color.primary87()
        controller.searchBar.searchTextField.backgroundColor = R.color.themePrimary()
        controller.searchBar.autocorrectionType = .no
        controller.searchBar.autocapitalizationType = .none

        controller.obscuresBackgroundDuringPresentation = false

        controller.searchResultsUpdater = self

        return controller
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectLesson: ((_ lessonId: String) -> Void)?
    var didTapAddLesson: (() -> Void)?

    // MARK: - Properties

    private let viewModel: LessonManagementViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: LessonManagementViewModel) {
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

        viewModel.loadData()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()

        title = Strings.lessonManagementNavTitle()
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        let addButton = UIBarButtonItem(
            image: R.icon.plus,
            style: .plain,
            target: self,
            action: #selector(addLessonAction)
        )
        addButton.tintColor = R.color.brandPrimary()
        navigationItem.rightBarButtonItem = addButton

        view.addSubview(tableView)

        tableView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))
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

        viewModel.$updateDataEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(
                    Strings.errorTitle(),
                    message: error.localizedDescription,
                    controller: self
                )
            }
            .store(in: &subscriptions)
    }

    // MARK: - UI Callbacks

    @objc private func addLessonAction() {
        didTapAddLesson?()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LessonManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredLessons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LessonManagementCell = tableView.dequeueReusableCell(for: indexPath)

        cell.configureWith(model: viewModel.filteredLessons[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        (tableView.cellForRow(at: indexPath) as? LessonManagementCell)?.performBlink()

        let item = viewModel.filteredLessons[indexPath.row]
        didSelectLesson?(item.lessonId)
    }
}

// MARK: - UISearchControllerDelegate

extension LessonManagementViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text ?? ""

        viewModel.setFilterText(searchQuery)
    }
}

// MARK: - LessonRefreshable

extension LessonManagementViewController: LessonRefreshable {
    func refreshLessons() {
        viewModel.loadData()
    }
}
