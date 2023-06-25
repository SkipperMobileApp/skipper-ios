//
//  MentorProfileCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Foundation

class MentorProfileCoordinator: NavigationCoordinator {
    var didFinish: (() -> Void)?

    init(with router: NavigationRouter, mentorId: String) {
        super.init(with: router)

        let viewModel = MentorProfileViewModel(mentorId: mentorId)
        let controller = MentorProfileViewController(viewModel: viewModel)

        controller.didSelectLesson = { [weak self] lessonId in
            self?.showBookingForLesson(lessonId: lessonId)
        }

        controller.didTapClassesList = { [weak self] in
            self?.showClassesList(mentorId: mentorId)
        }

        controller.didTapReportMentor = { [weak self] in
            self?.showReportMentor(for: mentorId)
        }

        controller.didFinish = { [weak self] in
            self?.didFinish?()
        }

        router.push(controller)
    }

    private func showClassesList(mentorId: String) {
        let viewModel = ClassesListViewModel(mentorId: mentorId)
        let controller = ClassesListViewController(viewModel: viewModel)

        controller.didSelectLesson = { [weak self] lessonId in
            self?.showBookingForLesson(lessonId: lessonId)
        }

        router.push(controller)
    }

    private func showBookingForLesson(lessonId: String) {
        let viewModel = BookingViewModel(lessonId: lessonId)
        let controller = BookingViewController(viewModel: viewModel)

        controller.didFinishBooking = { [weak self] in
            self?.router.popModule()
        }

        router.push(controller)
    }

    private func showReportMentor(for mentorId: String) {
        let viewModel = ReportMentorViewModel(mentorId: mentorId)
        let controller = ReportMentorViewController(viewModel: viewModel)

        controller.didTapClose = { [weak self] in
            self?.router.dismissModule()
        }

        controller.didSendReport = { [weak self] in
            self?.router.dismissModule()
        }

        router.present(controller)
    }
}
