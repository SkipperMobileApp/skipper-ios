//
//  MyLessonsCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 16.01.2023.
//

import Foundation

class MyLessonsCoordinator: NavigationCoordinator {
    var didTapOpenChat: ((_ chatId: String, _ opponentId: String) -> Void)?

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

    private func showLessonDetails(lessonId: String) {
        let viewModel = LessonDetailsViewModel(lessonId: lessonId)
        let controller = LessonDetailsViewController(viewModel: viewModel)

        controller.didCancelLesson = { [weak self] in
            self?.router.popModule()
        }

        controller.didTapMentorProfile = { [weak self] mentorId in
            self?.showMentorProfile(mentorId: mentorId)
        }

        controller.didTapSendMessage = { [weak self] chat in
            self?.didTapOpenChat?(chat.id, chat.opponent.id)
        }

        router.push(controller)
    }

    private func showMentorProfile(mentorId: String) {
        let coordinator = MentorProfileCoordinator(
            with: router,
            mentorId: mentorId
        )

        coordinator.didFinish = { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }

        addChild(coordinator)
    }
}
