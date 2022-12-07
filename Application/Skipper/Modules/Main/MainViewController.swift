//
//  MainViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import UIKit

class MainViewController: UIViewController {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        return label
    }()

    private lazy var logoutButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle("Sign Out", for: .normal)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?

    // MARK: - Properties

    private let viewModel: MainViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: MainViewModel) {
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

        label.frame = view.bounds

        logoutButton.frame = .init(x: 100, y: 100, width: 100, height: 50)
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(logoutButton)
    }

    private func bindViewModelActions() {
        viewModel.didFail = { [weak self] error in
            guard let self = self else { return }

            AlertPresenter.presentSimpleAlert(error.localizedDescription, controller: self)
        }
    }

    @objc private func signOut() {
        viewModel.signOut()
    }
}
