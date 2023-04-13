//
//  SignUpViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 28.11.2022.
//

import Foundation
import PKHUD
import TPKeyboardAvoiding
import UIKit

class SignUpViewController: UIViewController {
    typealias Field = SignUpViewModel.Field

    // MARK: - UI Components

    private lazy var scrollView: TPKeyboardAvoidingScrollView = {
        let scrollView = TPKeyboardAvoidingScrollView()
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var signUpButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle(Strings.authSignUpButtonText(), for: .normal)
        button.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        return button
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.promo
        label.textColor = R.color.primary87()
        label.text = Strings.authSignUpHeaderText()
        label.textAlignment = .center
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UnderlinedButton()
        button.setTitle(Strings.authSignUpLoginButtonText(), for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()

    private var fields: [Field: FormFieldView] = [:]

    // MARK: - Output

    var didSignUp: (() -> Void)?
    var didTapLogin: (() -> Void)?

    // MARK: - Properties

    private let viewModel: SignUpViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
    }

    init(viewModel: SignUpViewModel) {
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

        let containerView = UIView()

        containerView.addSubview(headerLabel)
        containerView.addSubview(stackView)
        containerView.addSubview(loginButton)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)

        scrollView.applyConstraints(.fit(in: view.safeAreaLayoutGuide))

        containerView.applyConstraints(
            .width(to: scrollView, attribute: .width),
            .height(to: scrollView, attribute: .height, equality: .greaterThanOrEqual),
            .fit(in: scrollView.contentLayoutGuide)
        )

        headerLabel.applyConstraints(
            .top(to: containerView, attribute: .top, constant: 10, equality: .greaterThanOrEqual),
            .centerX(to: containerView, attribute: .centerX),
            .bottom(to: stackView, attribute: .top, constant: -100)
        )

        stackView.applyConstraints(
            .centerY(to: containerView, attribute: .centerY, equality: .lessThanOrEqual),
            .leading(to: containerView, attribute: .leading, constant: 32),
            .trailing(to: containerView, attribute: .trailing, constant: -32),
            .top(to: containerView, attribute: .top, constant: 10, equality: .greaterThanOrEqual)
        )

        loginButton.applyConstraints(
            .top(to: stackView, attribute: .bottom, constant: 10, equality: .greaterThanOrEqual),
            .bottom(to: containerView, attribute: .bottom, constant: -25),
            .centerX(to: containerView, attribute: .centerX),
            .height(constant: 45)
        )

        assembleForm()
    }

    private func assembleForm() {
        let fieldViews = Field.allCases.map { field in
            let fieldView = makeFieldView(field)

            stackView.addArrangedSubview(fieldView)
            stackView.setCustomSpacing(15, after: fieldView)

            fields[field] = fieldView
            return fieldView
        }

        stackView.setCustomSpacing(67, after: fieldViews.last!)

        signUpButton.applyConstraints(.height(constant: 45))
        stackView.addArrangedSubview(signUpButton)
    }

    private func bindViewModelActions() {
        viewModel.didSignUp = { [weak self] in
            self?.setSignUpButtonLoading(false)

            HUD.show(.labeledSuccess(title: nil, subtitle: "Registered successfully"))
            HUD.hide(afterDelay: 1) { _ in
                self?.didSignUp?()
            }
        }

        viewModel.didFail = { [weak self] error in
            guard let self = self else { return }

            self.setSignUpButtonLoading(false)
            AlertPresenter.presentSimpleAlert(
                Strings.errorTitle(),
                message: error.localizedDescription,
                controller: self
            )
        }
    }

    private func signUp() {
        let values = fields.mapValues { $0.text ?? "" }

        let validationResult = viewModel.validate(values: values)

        guard validationResult.isEmpty else {
            applyErrors(validationResult)
            return
        }

        setSignUpButtonLoading(true)

        viewModel.signUp(values: values)
    }

    private func applyErrors(_ errors: [Field: [String]]) {
        Field.allCases.forEach { field in
            var state: FormFieldView.ErrorState = .none

            if let errorStrings = errors[field] {
                state = .errors(errorStrings)
            }

            self.fields[field]?.setErrorState(state)
        }
    }

    private func setSignUpButtonLoading(_ isLoading: Bool) {
        signUpButton.isLoading = isLoading
        signUpButton.isUserInteractionEnabled = !isLoading
    }

    // MARK: - Component Builders

    private func makeFieldView(_ field: Field) -> FormFieldView {
        let view = FormFieldView()

        view.placeholder = field.placeholderText
        view.style = field.fieldStyle
        view.delegate = self

        return view
    }

    // MARK: - UI Callback

    @objc private func signUpAction() {
        signUp()
    }

    @objc private func loginAction() {
        didTapLogin?()
    }
}

extension SignUpViewController: FormFieldViewDelegate {
    func formFieldViewShouldReturn(_ view: FormFieldView) {
        if fields[.password] === view {
            signUp()
            self.view.endEditing(true)
            return
        }

        scrollView.focusNextTextField()
    }

    func formFieldViewDidChangeText(_ view: FormFieldView, newText: String?) {
        view.setErrorState(.none)
    }
}
