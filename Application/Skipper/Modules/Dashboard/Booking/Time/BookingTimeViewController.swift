//
//  BookingTimeViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation
import UIKit

class BookingTimeViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var headerView: BookingHeaderView = {
        let view = BookingHeaderView()
        view.configureWith(title: "Даты занятий")
        return view
    }()

    private lazy var calendarView: UICalendarView = {
        let view = UICalendarView()

        view.tintColor = R.color.brandPrimary()
        view.fontDesign = .default

        view.calendar = Calendar.current
        view.timeZone = TimeZone.current

        view.availableDateRange = viewModel.bookableDateInterval

        view.delegate = self
        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)

        return view
    }()

    private lazy var headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false

        headerContainerView.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: 470)
        tableView.tableHeaderView = headerContainerView
        tableView.tableFooterView = UIView()

        tableView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)

        tableView.register(cellType: BookingTimeCell.self)
        tableView.register(headerFooterViewType: BookingTimeSectionHeader.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    private lazy var nextButton: PrimaryButton = {
        let button = PrimaryButton()
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.setTitle("Далее", for: .normal)
        return button
    }()

    private lazy var pickerPresenter: PickerPresenter = {
        let presenter = PickerPresenter()
        presenter.delegate = self
        return presenter
    }()

    private var tableHeaderView: BookingTimeSectionHeader?

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapNext: (() -> Void)?

    // MARK: - Properties

    private let viewModel: BookingTimeViewModel

    private var selectedDateComponents: DateComponents?

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: BookingTimeViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadCalendarData()
        reloadTableData()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""

        view.addSubview(tableView)
        view.addSubview(nextButton)
        headerContainerView.addSubview(headerView)
        headerContainerView.addSubview(calendarView)

        tableView.applyConstraints(
            .top(to: view, attribute: .top, constant: 16),
            .leading(to: view, attribute: .leading),
            .trailing(to: view, attribute: .trailing),
            .bottom(to: nextButton, attribute: .top, constant: -16)
        )

        nextButton.applyConstraints(
            .leading(to: view, attribute: .leading, constant: 16),
            .trailing(to: view, attribute: .trailing, constant: -16),
            .bottom(to: view, attribute: .bottom, constant: -64),
            .height(constant: 45)
        )

        headerView.applyConstraints(
            .top(to: headerContainerView, attribute: .top),
            .leading(to: headerContainerView, attribute: .leading),
            .trailing(to: headerContainerView, attribute: .trailing)
        )

        calendarView.applyConstraints(
            .top(to: headerView, attribute: .bottom, constant: 0),
            .leading(to: headerContainerView, attribute: .leading, constant: 16),
            .trailing(to: headerContainerView, attribute: .trailing, constant: -16),
            .bottom(to: headerContainerView, attribute: .bottom, constant: -16, equality: .lessThanOrEqual)
        )
    }

    private func bindViewModelActions() {}

    private func reloadTableData() {
        tableView.reloadData()
    }

    private func reloadCalendarData() {
        let components = viewModel.bookableDateComponents()
        calendarView.reloadDecorations(forDateComponents: components, animated: false)
    }

    private func updateTableHeader() {
        tableHeaderView?.configureWith(
            title: "Выбранные даты (осталось \(viewModel.remainingItemsAmountForSelection))"
        )
    }

    // MARK: - UI Callbacks

    @objc private func nextAction() {
        didTapNext?()
    }
}

// MARK: - UICalendarViewDelegate

extension BookingTimeViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView,
                      decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration?
    {
        guard let date = dateComponents.date else { return nil }

        if !calendarView.availableDateRange.contains(date) { return nil }

        let status = viewModel.statusFor(date: date)

        return status.indicatorColor.flatMap {
            UICalendarView.Decoration.default(color: $0, size: .small)
        }
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate

extension BookingTimeViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       canSelectDate dateComponents: DateComponents?) -> Bool
    {
        guard let date = dateComponents?.date else { return false }

        if viewModel.isMaximumItemsSelected { return false }

        let status = viewModel.statusFor(date: date)

        return Calendar.current.startOfDay(for: Date()) <= date &&
            status != .notAvailable
    }

    func dateSelection(_ selection: UICalendarSelectionSingleDate,
                       didSelectDate dateComponents: DateComponents?)
    {
        guard let date = dateComponents?.date else { return }

        viewModel.loadIntervalsFor(date: date)

        if viewModel.availableBookingIntervals.isEmpty {
            return
        }

        selectedDateComponents = dateComponents

        pickerPresenter.presentPicker(pickerData: .init(title: "Выберите время",
                                                        items: viewModel.availableBookingIntervals.map { $0.time },
                                                        selectedIndex: nil))
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension BookingTimeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.selectedTimeItems.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: BookingTimeSectionHeader? = tableView.dequeueReusableHeaderFooterView()
        tableHeaderView = view
        updateTableHeader()
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookingTimeCell = tableView.dequeueReusableCell(for: indexPath)

        let item = viewModel.selectedTimeItems[indexPath.row]

        cell.configureWith(date: DateHelper.Formatters.fullDateFormatter.string(from: item.date),
                           time: item.timeInterval)

        cell.didTapDelete = { [weak self] in
            guard let self = self,
                  let actualIndexPath = tableView.indexPath(for: cell) else { return }

            let date = self.viewModel.selectedTimeItems[actualIndexPath.row].date

            self.viewModel.deleteSelectedItem(at: actualIndexPath.row)
            self.tableView.deleteRows(at: [actualIndexPath], with: .fade)

            self.reloadCalendarData()
            self.updateTableHeader()
        }

        return cell
    }
}

// MARK: - PickerPresenterDelegate

extension BookingTimeViewController: PickerPresenterDelegate {
    func pickerPresenter(_ presenter: PickerPresenter, didSelectItemAtIndex index: Int) {
        guard let selectedDateComponents = selectedDateComponents,
              let selectedDate = selectedDateComponents.date else { return }

        viewModel.selectInterval(at: index, for: selectedDate)

        presenter.dismiss()

        reloadTableData()
        reloadCalendarData()
    }
}
