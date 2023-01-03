//
//  SearchCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Foundation

class SearchCoordinator: NavigationCoordinator {
    override init(with router: NavigationRouter) {
        super.init(with: router)

        let viewModel = SearchViewModel()
        let controller = SearchViewController(viewModel: viewModel)

        router.navigationController.setNavigationBarHidden(true, animated: false)
        router.setRootModule(controller)
    }
}
