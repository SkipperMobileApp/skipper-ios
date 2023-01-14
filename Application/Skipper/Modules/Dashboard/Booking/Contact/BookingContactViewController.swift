//
//  BookingContactViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation
import UIKit

class BookingContactViewController: UIViewController {
    // MARK: - Definitions

    typealias BookingContactType = BookingContactViewModel.BookingContactType

    // MARK: - UI Controls

    private lazy var bookButton: PrimaryButton = {
        let button = PrimaryButton()
        button.addTarget(self, action: #selector(bookAction), for: .touchUpInside)
        button.setTitle("Записаться", for: .normal)
        return button
    }()

    private lazy var headerView: BookingHeaderView = {
        let view = BookingHeaderView()
        view.configureWith(title: "Связь с ментором")
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        headerView.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: 60)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()

        tableView.register(cellType: BookingContactCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapBook: (() -> Void)?

    // MARK: - Properties

    private let viewModel: BookingContactViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: BookingContactViewModel) {
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
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonTitle = ""

        view.addSubview(tableView)
        view.addSubview(bookButton)

        tableView.applyConstraints(
            .top(to: view, attribute: .top, constant: 16),
            .leading(to: view, attribute: .leading),
            .trailing(to: view, attribute: .trailing),
            .bottom(to: bookButton, attribute: .top, constant: -16)
        )

        bookButton.applyConstraints(
            .leading(to: view, attribute: .leading, constant: 16),
            .trailing(to: view, attribute: .trailing, constant: -16),
            .bottom(to: view, attribute: .bottom, constant: -64),
            .height(constant: 45)
        )
    }

    private func save() {
        didTapBook?()
    }

    // MARK: - UI Callbacks

    @objc private func bookAction() {
        save()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension BookingContactViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.contactTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookingContactCell = tableView.dequeueReusableCell(for: indexPath)
        let item = viewModel.contactTypes[indexPath.row]

        cell.configureWith(title: item.title, image: item.image)

        cell.isSelected = viewModel.selectedContactIndex == indexPath.row

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedIndex(indexPath.row)

        for i in 0 ..< viewModel.contactTypes.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) {
                cell.isSelected = false
            }
        }

        tableView.cellForRow(at: indexPath)?.isSelected = true
    }
}
