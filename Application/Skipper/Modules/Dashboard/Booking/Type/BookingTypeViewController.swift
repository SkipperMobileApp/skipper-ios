//
//  BookingTypeViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import UIKit

class BookingTypeViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var nextButton: PrimaryButton = {
        let button = PrimaryButton()
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.setTitle("Далее", for: .normal)
        return button
    }()

    private lazy var headerView: BookingHeaderView = {
        let view = BookingHeaderView()
        view.configureWith(title: "Тип занятия")
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never

        headerView.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: 60)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()

        tableView.register(cellType: BookingTypeCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapNext: (() -> Void)?

    // MARK: - Properties

    private let viewModel: BookingTypeViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: BookingTypeViewModel) {
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
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonTitle = ""

        view.addSubview(tableView)
        view.addSubview(nextButton)

        tableView.applyConstraints(
            .top(to: view.safeAreaLayoutGuide, attribute: .top, constant: 16),
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing),
            .bottom(to: nextButton, attribute: .top, constant: -16)
        )

        nextButton.applyConstraints(
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading, constant: 16),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing, constant: -16),
            .bottom(to: view.safeAreaLayoutGuide, attribute: .bottom, constant: -64),
            .height(constant: 45)
        )
    }

    private func bindViewModelActions() {}

    // MARK: - UI Callbacks

    @objc private func nextAction() {
        didTapNext?()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension BookingTypeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.typeItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookingTypeCell = tableView.dequeueReusableCell(for: indexPath)
        let item = viewModel.typeItems[indexPath.row]

        cell.configureWith(title: item.title, description: item.description)

        cell.isSelected = viewModel.selectedItemIndex == indexPath.row

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedItem(at: indexPath.row)

        for i in 0 ..< viewModel.typeItems.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) {
                cell.isSelected = false
            }
        }

        tableView.cellForRow(at: indexPath)?.isSelected = true
    }
}
