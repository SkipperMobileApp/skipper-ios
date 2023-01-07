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

    private lazy var pickerPresenter: PickerPresenter = {
        let presenter = PickerPresenter()
        presenter.delegate = self
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

        updateData()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonTitle = ""

        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(stackView)
        view.addSubview(nextButton)

        scrollView.applyConstraints(
            .top(to: view.safeAreaLayoutGuide, attribute: .top),
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing),
            .bottom(to: nextButton, attribute: .top, constant: -16)
        )

        containerView.applyConstraints(.fit(in: scrollView.contentLayoutGuide),
                                       .width(to: scrollView, attribute: .width))

        headerView.applyConstraints(
            .top(to: containerView, attribute: .top),
            .leading(to: containerView, attribute: .leading),
            .trailing(to: containerView, attribute: .trailing)
        )

        stackView.applyConstraints(
            .top(to: headerView, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .bottom(to: containerView, attribute: .bottom, constant: -16)
        )

        nextButton.applyConstraints(
            .leading(to: view.safeAreaLayoutGuide, attribute: .leading, constant: 16),
            .trailing(to: view.safeAreaLayoutGuide, attribute: .trailing, constant: -16),
            .bottom(to: view.safeAreaLayoutGuide, attribute: .bottom, constant: -64),
            .height(constant: 45)
        )
    }

    private func updateData() {
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
        pickerPresenter.presentPicker(
            pickerData: .init(
                title: "Длительность занятия",
                items: viewModel.durationItems.map { $0.title },
                selectedIndex: viewModel.selectedDurationIndex
            )
        )
        pickerMode = .duration
    }

    @objc private func amountAction() {
        pickerPresenter.presentPicker(
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

extension BookingAmountViewController: PickerPresenterDelegate {
    func pickerPresenter(_ presenter: PickerPresenter, didSelectItemAtIndex index: Int) {
        if pickerMode == .duration {
            viewModel.setSelectedDuration(at: index)
            durationButton.text = viewModel.durationItems[index].title
        } else {
            viewModel.setSelectedAmount(at: index)
            amountButton.text = viewModel.amountItems[index].title
        }
        pickerPresenter.dismiss()
    }
}
