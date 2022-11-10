//
//  AuthViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import UIKit

class AuthViewController: UIViewController {
    private lazy var loginButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(R.string.localizable.authLoginButtonText(), for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()

    private lazy var registerButton: TextButton = {
        let button = TextButton()
        button.setTitle(R.string.localizable.authRegisterButtonText(), for: .normal)
        button.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapRegister: (() -> Void)?

    // MARK: - Properties

    private let viewModel: AuthViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
    }

    init(viewModel: AuthViewModel) {
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        loginButton.frame.size = CGSize(width: 200, height: 42)
        loginButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        registerButton.frame.size = CGSize(width: 200, height: 42)
        registerButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 100)
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }

    private func bindViewModelActions() {
        viewModel.didLogin = { [weak self] in
            self?.didFinish?()
        }
    }

    // MARK: - UI Callbacks

    @objc private func loginAction() {
        viewModel.login()
    }

    @objc private func registerAction() {
        didTapRegister?()
    }
}
