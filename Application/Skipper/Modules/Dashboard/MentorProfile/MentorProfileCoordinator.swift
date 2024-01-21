//
//  MentorProfileCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Combine
import Foundation
import UIKit

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

        controller.didTapReviewsList = { [weak self] in
            self?.showReviewsList(mentorId: mentorId)
        }

        controller.didTapAddReview = { [weak self] addReviewSubject in
            self?.showAddReview(mentorId: mentorId, addReviewSubject: addReviewSubject)
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

    private func showReviewsList(mentorId: String) {
        let viewModel = ReviewsListViewModel(userId: mentorId)
        let controller = ReviewsListViewController(viewModel: viewModel)

        router.push(controller)
    }

    private func showAddReview(
        mentorId: String,
        addReviewSubject: PassthroughSubject<Void, Never>
    ) {
        let viewModel = AddReviewViewModel(
            targetUserId: mentorId,
            addReviewSubject: addReviewSubject
        )
        let controller = AddReviewViewController(viewModel: viewModel)

        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve

        controller.didFinish = { [weak controller] in
            controller?.dismiss(animated: true)
        }

        UIApplication.shared.windows
            .first { $0.isKeyWindow }?
            .rootViewController?
            .present(controller, animated: true)
    }
}
