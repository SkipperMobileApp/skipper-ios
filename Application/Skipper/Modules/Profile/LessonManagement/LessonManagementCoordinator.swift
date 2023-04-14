//
//  LessonManagementCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.04.2023.
//

import Foundation
import UIKit

// MARK: - Protocols

protocol LessonRefreshable: UIViewController {
    func refreshLessons()
}

// MARK: - Coordinator

class LessonManagementCoordinator: NavigationCoordinator {
    var didFinish: (() -> Void)?

    override init(with router: NavigationRouter) {
        super.init(with: router)

        let viewModel = LessonManagementViewModel()
        let controller = LessonManagementViewController(viewModel: viewModel)

        controller.didFinish = { [weak self] in
            self?.didFinish?()
        }

        controller.didSelectLesson = { [weak self, weak controller] lessonId in
            guard let controller = controller else { return }
            self?.showLessonDetails(lessonId: lessonId, lessonRefreshable: controller)
        }

        controller.didTapAddLesson = { [weak self, weak controller] in
            guard let controller = controller else { return }
            self?.showAddLesson(lessonRefreshable: controller)
        }

        router.push(controller)
    }

    // MARK: - Routing

    func showLessonDetails(lessonId: String, lessonRefreshable: LessonRefreshable) {}

    func showAddLesson(lessonRefreshable: LessonRefreshable) {}
}
