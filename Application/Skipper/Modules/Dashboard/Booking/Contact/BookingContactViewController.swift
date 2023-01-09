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

    private var fieldViews: [BookingContactType: BookingContactItemView] = [:]

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
        view.addSubview(bookButton)

        scrollView.applyConstraints(
            .top(to: view, attribute: .top),
            .leading(to: view, attribute: .leading),
            .trailing(to: view, attribute: .trailing),
            .bottom(to: bookButton, attribute: .top, constant: -16)
        )

        containerView.applyConstraints(.fit(in: scrollView.contentLayoutGuide),
                                       .width(to: scrollView, attribute: .width))

        headerView.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 16),
            .leading(to: containerView, attribute: .leading),
            .trailing(to: containerView, attribute: .trailing),
            .height(constant: 60)
        )

        stackView.applyConstraints(
            .top(to: headerView, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading),
            .trailing(to: containerView, attribute: .trailing),
            .bottom(to: containerView, attribute: .bottom, constant: -16)
        )

        bookButton.applyConstraints(
            .leading(to: view, attribute: .leading, constant: 16),
            .trailing(to: view, attribute: .trailing, constant: -16),
            .bottom(to: view, attribute: .bottom, constant: -64),
            .height(constant: 45)
        )
    }

    private func updateData() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        viewModel.contactTypes.map(makeField).forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func save() {
        let values = fieldViews.mapValues { $0.value }
        viewModel.saveContactValues(values)
        didTapBook?()
    }

    // MARK: - UI Builders

    private func makeField(for type: BookingContactType) -> UIView {
        let view = BookingContactItemView()

        view.configureWith(title: type.title, imageURL: type.imageURL, fieldPlaceholder: type.placeholder)

        return view
    }

    // MARK: - UI Callbacks

    @objc private func bookAction() {
        save()
    }
}
