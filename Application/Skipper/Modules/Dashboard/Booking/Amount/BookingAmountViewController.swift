//
//  BookingAmountViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import UIKit

class BookingAmountViewController: UIViewController {
    // MARK: - Definitions

    private enum PickerMode {
        case amount, duration
    }

    // MARK: - UI Controls

    private lazy var nextButton: PrimaryButton = {
        let button = PrimaryButton()
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.setTitle("Далее", for: .normal)
        return button
    }()

    private lazy var headerView: BookingHeaderView = {
        let view = BookingHeaderView()
        view.configureWith(title: "Опции занятия")
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()

    private lazy var durationButton: DropdownButton = {
        let button = DropdownButton()
        button.placeholder = "Выберите длительность"
        button.addTarget(self, action: #selector(durationAction), for: .touchUpInside)
        return button
    }()

    private lazy var amountButton: DropdownButton = {
        let button = DropdownButton()
        button.placeholder = "Выберите количество"
        button.addTarget(self, action: #selector(amountAction), for: .touchUpInside)
        return button
    }()

//    private lazy var totalLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = R.color.primary87()
//        label.font = R.typo.header
//        label.numberOfLines = 1
//        return label
//    }()

    private lazy var pickerPresenter: PickerPresenter = {
        let presenter = PickerPresenter()
        presenter.itemDelegate = self
        return presenter
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapNext: (() -> Void)?

    // MARK: - Properties

    private let viewModel: BookingAmountViewModel

    private var pickerMode: PickerMode?

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: BookingAmountViewModel) {
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

        updateUI()
        updateData()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""

        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(stackView)
        view.addSubview(nextButton)

        scrollView.applyConstraints(
            .top(to: view, attribute: .top),
            .leading(to: view, attribute: .leading),
            .trailing(to: view, attribute: .trailing),
            .bottom(to: nextButton, attribute: .top, constant: -16)
        )

        containerView.applyConstraints(
            .fit(in: scrollView.contentLayoutGuide),
            .width(to: scrollView, attribute: .width)
        )

        headerView.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 16),
            .leading(to: containerView, attribute: .leading),
            .trailing(to: containerView, attribute: .trailing),
            .height(constant: 60)
        )

        stackView.applyConstraints(
            .top(to: headerView, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .bottom(to: containerView, attribute: .bottom, constant: -16)
        )

        nextButton.applyConstraints(
            .leading(to: view, attribute: .leading, constant: 16),
            .trailing(to: view, attribute: .trailing, constant: -16),
            .bottom(to: view, attribute: .bottom, constant: -64),
            .height(constant: 45)
        )
    }

    private func updateUI() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let durationHeader = makeButtonHeader(text: "Длительность занятий")
        stackView.addArrangedSubview(durationHeader)
        stackView.setCustomSpacing(8, after: durationHeader)

        durationButton.applyConstraints(.height(constant: 50))
        stackView.addArrangedSubview(durationButton)
        stackView.setCustomSpacing(16, after: durationButton)

        let amountHeader = makeButtonHeader(text: "Количество занятий")
        stackView.addArrangedSubview(amountHeader)
        stackView.setCustomSpacing(8, after: amountHeader)

        amountButton.applyConstraints(.height(constant: 50))
        stackView.addArrangedSubview(amountButton)
        stackView.setCustomSpacing(16, after: amountButton)

//        stackView.addArrangedSubview(totalLabel)
//        stackView.setCustomSpacing(16, after: totalLabel)
    }

    private func updateData() {
        // totalLabel.text = "Итоговая стоимость: \(viewModel.totalCost) рублей"
        amountButton.text = viewModel.selectedAmountIndex
            .flatMap { viewModel.amountItems[$0].title }
        durationButton.text = viewModel.selectedDurationIndex
            .flatMap { viewModel.durationItems[$0].title }
    }

    private func bindViewModelActions() {}

    // MARK: - UI Builders

    private func makeButtonHeader(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let label = UILabel()
        label.font = R.typo.body
        label.text = text
        label.textColor = R.color.primary54()
        label.numberOfLines = 1

        container.addSubview(label)
        label.applyConstraints(
            .leading(to: container, attribute: .leading, constant: 8),
            .top(to: container, attribute: .top),
            .bottom(to: container, attribute: .bottom),
            .trailing(to: container, attribute: .trailing, constant: -8)
        )

        return container
    }

    // MARK: - UI Callbacks

    @objc private func nextAction() {
        didTapNext?()
    }

    @objc private func durationAction() {
        pickerPresenter.presentItemPicker(
            pickerData: .init(
                title: "Длительность занятия",
                items: viewModel.durationItems.map { $0.title },
                selectedIndex: viewModel.selectedDurationIndex
            )
        )
        pickerMode = .duration
    }

    @objc private func amountAction() {
        pickerPresenter.presentItemPicker(
            pickerData: .init(
                title: "Количество занятий",
                items: viewModel.amountItems.map { $0.title },
                selectedIndex: viewModel.selectedAmountIndex
            )
        )
        pickerMode = .amount
    }
}

// MARK: - PickerPresenterDelegate

extension BookingAmountViewController: ItemPickerDelegate {
    func itemPicker(_ presenter: PickerPresenter, didSelectItemAtIndex index: Int) {
        if pickerMode == .duration {
            viewModel.setSelectedDuration(at: index)
        } else {
            viewModel.setSelectedAmount(at: index)
        }

        updateData()

        pickerPresenter.dismiss()
    }
}
