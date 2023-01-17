//
//  AuthVerificationViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 29.12.2022.
//

import Foundation
import PKHUD
import UIKit

class AuthVerificationViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.authVerificationHeaderText()
        label.font = R.typo.promo2
        label.textColor = R.color.primary87()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.authVerificationBodyText()
        label.font = R.typo.header3
        label.textColor = R.color.primary87()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var resendButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle(Strings.authVerificationResendButtonText(), for: .normal)
        button.addTarget(self, action: #selector(resendAction), for: .touchUpInside)
        return button
    }()

    private lazy var signInButton: UnderlinedButton = {
        let button = UnderlinedButton()
        button.setTitle(Strings.authVerificationSignInButtonText(), for: .normal)
        button.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Outputs

    var didFinish: (() -> Void)?

    // MARK: - Properties

    private let viewModel: AuthVerificationViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
    }

    init(viewModel: AuthVerificationViewModel) {
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

        view.addSubview(headerLabel)
        view.addSubview(bodyLabel)
        view.addSubview(resendButton)
        view.addSubview(signInButton)

        headerLabel.applyConstraints(
            .top(to: view, attribute: .top, constant: 100),
            .centerX(to: view, attribute: .centerX),
            .leading(to: view, attribute: .leading, constant: 32, equality: .greaterThanOrEqual),
            .trailing(to: view, attribute: .trailing, constant: -32, equality: .lessThanOrEqual)
        )

        bodyLabel.applyConstraints(
            .top(to: headerLabel, attribute: .bottom, constant: 32),
            .centerX(to: view, attribute: .centerX),
            .leading(to: view, attribute: .leading, constant: 32, equality: .greaterThanOrEqual),
            .trailing(to: view, attribute: .trailing, constant: -32, equality: .lessThanOrEqual)
        )

        resendButton.applyConstraints(
            .top(to: bodyLabel, attribute: .bottom, constant: 100),
            .centerX(to: view, attribute: .centerX),
            .leading(to: view, attribute: .leading, constant: 32, equality: .greaterThanOrEqual),
            .trailing(to: view, attribute: .trailing, constant: -32, equality: .lessThanOrEqual),
            .height(constant: 45)
        )

        signInButton.applyConstraints(
            .top(to: resendButton, attribute: .bottom, constant: 32, equality: .greaterThanOrEqual),
            .centerX(to: view, attribute: .centerX),
            .leading(to: view, attribute: .leading, constant: 32, equality: .greaterThanOrEqual),
            .trailing(to: view, attribute: .trailing, constant: -32, equality: .lessThanOrEqual),
            .bottom(to: view, attribute: .bottom, constant: -24)
        )
    }

    private func bindViewModelActions() {
        viewModel.didResendEmail = {
            HUD.show(.labeledSuccess(title: nil, subtitle: "Email resent"))
            HUD.hide(afterDelay: 1) { [weak self] _ in
                self?.didFinish?()
            }
        }

        viewModel.didFail = { [weak self] error in
            guard let self = self else { return }
            AlertPresenter.presentSimpleAlert("Ошибка", message: error.localizedDescription,
                                              controller: self)
        }
    }

    // MARK: - UI Callbacks

    @objc private func resendAction() {
        viewModel.resendVerificationEmail()
    }

    @objc private func signInAction() {
        didFinish?()
    }
}
