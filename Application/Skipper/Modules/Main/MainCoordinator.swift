//
//  MainCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

class MainCoordinator: NavigationCoordinator {
    var didFinish: (() -> Void)?

    override init(with router: NavigationRouter, session: AppSession) {
        super.init(with: router, session: session)

        let viewModel = MainViewModel(session: session)
        let controller = MainViewController(viewModel: viewModel)

        controller.didFinish = { [weak self] in
            self?.didFinish?()
        }

        router.setRootModule(controller)
    }
}
