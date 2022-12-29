//
//  ProfileViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Combine
import Foundation
import PKHUD
import UIKit

class ProfileViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var logoutButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?

    // MARK: - Properties

    private let viewModel: ProfileViewModel

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ProfileViewModel) {
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

        view.addSubview(logoutButton)
        logoutButton.frame = .init(x: 100, y: 100, width: 100, height: 50)
    }

    private func bindViewModelActions() {
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    HUD.show(.progress, onView: self?.view)
                } else {
                    HUD.hide()
                }
            }
            .store(in: &subscriptions)

        viewModel.$failEvent
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.presentSimpleAlert(error.localizedDescription, controller: self)
            }
            .store(in: &subscriptions)
    }

    // MARK: - UI Callbacks

    @objc private func logoutAction() {
        viewModel.logout()
    }
}
