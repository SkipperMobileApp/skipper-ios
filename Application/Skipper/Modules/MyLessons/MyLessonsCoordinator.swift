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

        controller.didSelectLesson = { [weak self] lessonId in
            self?.showLessonDetails(lessonId: lessonId)
        }

        router.navigationController.navigationItem.largeTitleDisplayMode = .always
        router.navigationController.navigationBar.prefersLargeTitles = true

        router.setRootModule(controller)
    }

    func showLessonDetails(lessonId: String) {
        let viewModel = LessonDetailsViewModel(lessonId: lessonId)
        let controller = LessonDetailsViewController(viewModel: viewModel)

        controller.didCancelLesson = { [weak self] in
            self?.router.popModule()
        }

        router.push(controller)
    }
}
