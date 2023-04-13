//
//  MyLessonsViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 16.01.2023.
//

import Combine
import Foundation
import PKHUD
import UIKit

class MyLessonsViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = .clear
        tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        tableView.register(cellType: MyLessonsCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectLesson: ((_ lessonId: String) -> Void)?

    // MARK: - Properties

    private let viewModel: MyLessonsViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: MyLessonsViewModel) {
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
        view.backgroundColor = R.color.themeBackground()

        title = Strings.myLessonsNavTitle()
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .always

        view.addSubview(tableView)

        tableView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))
    }

    private func bindViewModelActions() {
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            }
            .store(in: &subscriptions)

        viewModel.$loadDataEvent
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyLessonsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.lessonItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyLessonsCell = tableView.dequeueReusableCell(for: indexPath)

        cell.configureWith(item: viewModel.lessonItems[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        (tableView.cellForRow(at: indexPath) as? MyLessonsCell)?.performBlink()

        let item = viewModel.lessonItems[indexPath.row]
        didSelectLesson?(item.lessonId)
    }
}
