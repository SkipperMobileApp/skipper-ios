//
//  ReviewsListViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2024.
//

import Combine
import Foundation
import PKHUD
import UIKit

class ReviewsListViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        tableView.separatorStyle = .none

        tableView.register(cellType: ReviewsListCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectLesson: ((_ id: String) -> Void)?

    // MARK: - Properties

    private let viewModel: ReviewsListViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ReviewsListViewModel) {
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

        title = "Отзывы"

        view.addSubview(tableView)
        tableView.applyConstraints(.fit(in: view))
    }

    private func bindViewModelActions() {
        viewModel.$loadDataEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                isLoading ? HUD.show(.progress) : HUD.hide()
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
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ReviewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.reviewItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReviewsListCell = tableView.dequeueReusableCell(for: indexPath)
        let item = viewModel.reviewItems[indexPath.row]

        cell.configure(with: item)

        return cell
    }
}
