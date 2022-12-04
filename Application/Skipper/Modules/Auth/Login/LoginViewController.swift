//
//  LoginViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import TPKeyboardAvoiding
import UIKit

class LoginViewController: UIViewController {
    typealias Field = LoginViewModel.Field

    // MARK: - UI Controls

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

    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle(Strings.authLoginButtonText(), for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = R.typo.promo
        label.textColor = R.color.primary87()
        label.text = Strings.authLoginHeaderText()
        label.textAlignment = .center
        return label
    }()

    private lazy var signUpButton: UIButton = {
        let button = UnderlinedButton()
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        return button
    }()

    private var fields: [Field: FormFieldView] = [:]

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapSignUp: (() -> Void)?

    // MARK: - Properties

    private let viewModel: LoginViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
    }

    init(viewModel: LoginViewModel) {
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
        view.backgroundColor = .white

        let containerView = UIView()

        containerView.addSubview(stackView)
        containerView.addSubview(signUpButton)
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)

        scrollView.applyConstraints(.fit(in: view))

        containerView.applyConstraints(
            .width(to: scrollView.frameLayoutGuide, attribute: .width),
            .height(to: scrollView.frameLayoutGuide, attribute: .height, equality: .greaterThanOrEqual),
            .fit(in: scrollView.contentLayoutGuide)
        )

        stackView.applyConstraints(
            .centerY(to: containerView, attribute: .centerY, equality: .lessThanOrEqual),
            .leading(to: containerView, attribute: .leading, constant: 32),
            .trailing(to: containerView, attribute: .trailing, constant: -32),
            .top(to: containerView, attribute: .top, constant: 10, equality: .greaterThanOrEqual),
            .bottom(to: containerView, attribute: .bottom, constant: -70, equality: .lessThanOrEqual)
        )

        signUpButton.applyConstraints(
            .bottom(to: containerView, attribute: .bottom, constant: -25),
            .centerX(to: containerView, attribute: .centerX),
            .height(constant: 45)
        )

        assembleForm()

        #if DEBUG
        fields[.email]?.text = "test@test.test"
        fields[.password]?.text = "testtest"
        #endif
    }

    private func assembleForm() {
        stackView.addArrangedSubview(headerLabel)
        stackView.setCustomSpacing(100, after: headerLabel)

        let fieldViews = Field.allCases.map { field in
            let fieldView = makeFieldView(field)

            stackView.addArrangedSubview(fieldView)
            stackView.setCustomSpacing(25, after: fieldView)

            fields[field] = fieldView
            return fieldView
        }

        stackView.setCustomSpacing(70, after: fieldViews.last!)

        loginButton.applyConstraints(.height(constant: 45))
        stackView.addArrangedSubview(loginButton)
    }

    private func bindViewModelActions() {
        viewModel.didLogin = { [weak self] in
            self?.setLoginButtonLoading(false)
            self?.didFinish?()
        }

        viewModel.didFail = { [weak self] error in
            guard let self = self else { return }

            self.setLoginButtonLoading(false)
            AlertPresenter.presentSimpleAlert(Strings.errorTitle(),
                                              message: error.localizedDescription,
                                              controller: self)
        }
    }

    private func login() {
        let email = fields[.email]?.text ?? ""
        let password = fields[.password]?.text ?? ""

        let validationResult = viewModel.validate(values: [.email: email, .password: password])

        guard validationResult.isEmpty else {
            applyErrors(validationResult)
            return
        }

        setLoginButtonLoading(true)

        viewModel.login(email: email, password: password)
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

    private func setLoginButtonLoading(_ isLoading: Bool) {
        loginButton.isLoading = isLoading
        loginButton.isUserInteractionEnabled = !isLoading
    }

    // MARK: - Component Builders

    private func makeFieldView(_ field: Field) -> FormFieldView {
        let view = FormFieldView()

        view.placeholder = field.placeholderText
        view.style = field.fieldStyle
        view.delegate = self

        return view
    }

    // MARK: - UI Callbacks

    @objc private func loginAction() {
        login()
    }

    @objc private func signUpAction() {
        didTapSignUp?()
    }
}

// MARK: - FormFieldViewDelegate

extension LoginViewController: FormFieldViewDelegate {
    func formFieldViewShouldReturn(_ view: FormFieldView) {
        if fields[.password] === view {
            login()
            self.view.endEditing(true)
            return
        }

        scrollView.focusNextTextField()
    }

    func formFieldViewDidChangeText(_ view: FormFieldView, newText: String?) {
        view.setErrorState(.none)
    }
}
