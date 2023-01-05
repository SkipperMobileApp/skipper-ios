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

        controller.didTapCategory = { [weak self] category in
            self?.showSearchMentor(category: category)
        }

        router.navigationController.navigationItem.largeTitleDisplayMode = .always
        router.navigationController.navigationBar.prefersLargeTitles = true

        router.setRootModule(controller)
    }

    func showSearchMentor(category: String?) {
        let viewModel = SearchMentorViewModel(category: category)
        let controller = SearchMentorViewController(viewModel: viewModel)

        router.push(controller)
    }
}
