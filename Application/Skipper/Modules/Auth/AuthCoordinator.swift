//
//  AuthCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 28.11.2022.
//

import Foundation

class AuthCoordinator: NavigationCoordinator {
    var didFinish: (() -> Void)?

    override init(with router: NavigationRouter) {
        super.init(with: router)

        showSignIn()
    }

    private func showSignIn() {
        let viewModel = LoginViewModel()
        let controller = LoginViewController(viewModel: viewModel)

        controller.didFinish = { [weak self] in
            self?.didFinish?()
        }

        controller.didTapSignUp = { [weak self] in
            self?.showSignUp()
        }

        router.navigationController.setNavigationBarHidden(true, animated: false)
        router.setRootModule(controller, animated: true)
    }

    private func showSignUp() {
        let viewModel = SignUpViewModel()
        let controller = SignUpViewController(viewModel: viewModel)

        controller.didSignUp = { [weak self] in
            self?.didFinish?()
        }

        controller.didTapLogin = { [weak self] in
            self?.showSignIn()
        }

        router.navigationController.setNavigationBarHidden(true, animated: false)
        router.setRootModule(controller, animated: true)
    }
}
