//
//  DashboardCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Foundation

class DashboardCoordinator: NavigationCoordinator {
    override init(with router: NavigationRouter) {
        super.init(with: router)

        let viewModel = DashboardViewModel()
        let controller = DashboardViewController(viewModel: viewModel)

        router.navigationController.navigationItem.largeTitleDisplayMode = .always
        router.navigationController.navigationBar.prefersLargeTitles = true

        router.setRootModule(controller)
    }
}
