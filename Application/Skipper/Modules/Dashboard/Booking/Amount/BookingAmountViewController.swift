//
//  BookingAmountViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import UIKit

class BookingAmountViewController: UIViewController {
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

    private func bindViewModelActions() {}

    // MARK: - UI Callbacks

    @objc private func nextAction() {
        didTapNext?()
    }
}
