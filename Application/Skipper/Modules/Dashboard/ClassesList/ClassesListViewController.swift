//
//  ClassesListViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Combine
import Foundation
import PKHUD
import UIKit

class ClassesListViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero

        tableView.register(cellType: ClassesListCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectLesson: ((_ id: String) -> Void)?

    // MARK: - Properties

    private let viewModel: ClassesListViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ClassesListViewModel) {
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
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonTitle = ""

        title = "Список занятий"

        view.addSubview(tableView)
        tableView.applyConstraints(.fit(in: view))
    }

    private func bindViewModelActions() {
        viewModel.$loadDataEvent
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)

        viewModel.$isLoading
            .sink { isLoading in
                isLoading ? HUD.show(.progress) : HUD.hide()
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(error.localizedDescription, controller: self)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ClassesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ClassesListCell = tableView.dequeueReusableCell(for: indexPath)
        let item = viewModel.items[indexPath.row]

        cell.configureWith(title: item.title, description: item.description)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let id = viewModel.items[indexPath.row].id
        didSelectLesson?(id)
    }
}
