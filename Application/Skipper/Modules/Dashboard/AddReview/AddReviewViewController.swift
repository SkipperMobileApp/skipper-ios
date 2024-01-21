//
//  AddReviewViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 15.01.2024.
//

import Combine
import Foundation
import TPKeyboardAvoiding
import UIKit

class AddReviewViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var scrollView: UIScrollView = {
        let scrollView = TPKeyboardAvoidingScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear

        return scrollView
    }()

    private lazy var scrollViewContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)

        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        gesture.addTarget(self, action: #selector(tapAction))
        gesture.delegate = self

        view.addGestureRecognizer(gesture)
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.themeBackground()
        view.layer.cornerRadius = 12
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Текст отзыва:"
        label.textColor = R.color.primary87()
        label.font = R.typo.header
        label.numberOfLines = 1
        return label
    }()

    private lazy var contentTextView: PlaceholderTextView = {
        let view = PlaceholderTextView()
        view.placeholder = "Введите текст отзыва"
        view.placeholderTextColor = R.color.primary54()
        view.placeholderFont = R.typo.body
        view.font = R.typo.body
        view.textColor = R.color.primary87()
        view.layer.borderColor = R.color.brandPrimary()?.cgColor
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var ratingBar: RatingBar = {
        let view = RatingBar()
        view.configure(with: 0)
        view.selectedTintColor = R.color.brandPrimary()!
        view.normalTintColor = R.color.primary12()!
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.crossBold, for: .normal)
        button.tintColor = R.color.gray50()
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()

    private lazy var addButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Оставить отзыв", for: .normal)
        button.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return button
    }()

    private lazy var anonymousCheckbox: UIButton = {
        let button = UIButton()
        button.setImage(R.icon.checkboxOn, for: .selected)
        button.setImage(R.icon.checkboxOff, for: .normal)
        button.tintColor = R.color.brandPrimary()

        button.setTitle("Анонимный отзыв", for: .normal)
        button.setTitleColor(R.color.primary87(), for: .normal)
        button.titleLabel?.font = R.typo.body

        button.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -8)
        button.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 8)

        button.addTarget(self, action: #selector(changeAnonymousAction), for: .touchUpInside)

        return button
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?

    // MARK: - Properties

    private var subscriptions = Set<AnyCancellable>()

    private let viewModel: AddReviewViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
    }

    init(viewModel: AddReviewViewModel) {
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
        view.backgroundColor = .clear
        title = "Where to eat?"

        // view.addSubview(backgroundView)
        view.addSubview(scrollView)

        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.addSubview(containerView)

        containerView.addSubview(headerLabel)
        containerView.addSubview(contentTextView)
        containerView.addSubview(ratingBar)
        containerView.addSubview(cancelButton)
        containerView.addSubview(addButton)
        containerView.addSubview(anonymousCheckbox)

        // backgroundView.applyConstraints(.fit(in: view))

        scrollView.applyConstraints(.fit(in: view))

        scrollViewContentView.applyConstraints(
            .fit(in: scrollView.contentLayoutGuide),
            .width(to: scrollView, attribute: .width),
            .height(to: scrollView, attribute: .height, equality: .greaterThanOrEqual)
        )

        containerView.applyConstraints(
            .top(
                to: scrollViewContentView,
                attribute: .top,
                constant: 32,
                equality: .greaterThanOrEqual
            ),
            .bottom(
                to: scrollViewContentView,
                attribute: .bottom,
                constant: -32,
                equality: .lessThanOrEqual
            ),
            .leading(to: scrollViewContentView, attribute: .leading, constant: 32),
            .trailing(to: scrollViewContentView, attribute: .trailing, constant: -32),
            .centerY(to: scrollViewContentView, attribute: .centerY)
        )

        headerLabel.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16)
        )

        cancelButton.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 8),
            .trailing(to: containerView, attribute: .trailing, constant: -8),
            .height(constant: 28),
            .width(constant: 28)
        )

        contentTextView.applyConstraints(
            .top(to: headerLabel, attribute: .bottom, constant: 16),
            .leading(to: containerView, attribute: .leading, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .height(constant: 250)
        )

        anonymousCheckbox.applyConstraints(
            .top(to: contentTextView, attribute: .bottom, constant: 8),
            .leading(to: containerView, attribute: .leading, constant: 16)
        )

        ratingBar.applyConstraints(
            .top(to: anonymousCheckbox, attribute: .bottom, constant: 16),
            .leading(
                to: containerView,
                attribute: .leading,
                constant: 16,
                equality: .greaterThanOrEqual
            ),
            .trailing(
                to: containerView,
                attribute: .trailing,
                constant: -16,
                equality: .lessThanOrEqual
            ),
            .centerX(to: containerView, attribute: .centerX),
            .height(constant: 44)
        )

        addButton.applyConstraints(
            .leading(to: containerView, attribute: .leading, constant: 16),
            .top(to: ratingBar, attribute: .bottom, constant: 16),
            .trailing(to: containerView, attribute: .trailing, constant: -16),
            .bottom(to: containerView, attribute: .bottom, constant: -16),
            .height(constant: 40)
        )
    }

    private func bindViewModelActions() {
        viewModel.$addReviewEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.didFinish?()
            }
            .store(in: &subscriptions)

        viewModel.$errorEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(error.localizedDescription, controller: self)
            }
            .store(in: &subscriptions)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
            }
            .store(in: &subscriptions)
    }

    private func addReview() {
        let content = contentTextView.text ?? ""
        let rating = ratingBar.rating

        let validationResults = viewModel.validate(content: content, rating: rating)
        guard validationResults.isEmpty else {
            AlertPresenter.presentSimpleAlert(
                "Ошибка",
                message: validationResults.joined(separator: "\n"),
                controller: self
            )
            return
        }

        viewModel.addReview(
            content: content,
            rating: rating,
            isAnonymous: anonymousCheckbox.isSelected
        )
    }

    // MARK: - UI Callbacks

    @objc private func tapAction() {
        didFinish?()
    }

    @objc private func addAction() {
        addReview()
    }

    @objc private func cancelAction() {
        didFinish?()
    }

    @objc private func changeAnonymousAction(_ button: UIButton) {
        button.isSelected.toggle()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension AddReviewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
