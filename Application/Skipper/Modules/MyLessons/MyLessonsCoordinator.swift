//
//  MyLessonsCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 16.01.2023.
//

import Foundation

class MyLessonsCoordinator: NavigationCoordinator {
    override init(with router: NavigationRouter) {
        super.init(with: router)

        let viewModel = MyLessonsViewModel()
        let controller = MyLessonsViewController(viewModel: viewModel)

        controller.didSelectLesson = { _ in
        }

        router.navigationController.navigationItem.largeTitleDisplayMode = .always
        router.navigationController.navigationBar.prefersLargeTitles = true

        router.setRootModule(controller)
    }
}
