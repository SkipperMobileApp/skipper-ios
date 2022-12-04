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

        let viewModel = LoginViewModel()
        let controller = LoginViewController(viewModel: viewModel)

        controller.didFinish = { [weak self] in
            self?.didFinish?()
        }

        controller.didTapSignUp = { [weak self] in
            self?.showSignUp()
        }

        router.navigationController.setNavigationBarHidden(true, animated: false)

        router.setRootModule(controller)
    }

    private func showSignUp() {}
}
