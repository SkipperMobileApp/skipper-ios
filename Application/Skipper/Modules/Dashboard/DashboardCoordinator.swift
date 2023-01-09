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

        controller.didTapCategory = { [weak self] categoryId in
            self?.showSearchMentor(categoryId: categoryId)
        }

        controller.didTapMentor = { [weak self] mentorId in
            self?.showMentorProfile(mentorId: mentorId)
        }

        router.navigationController.navigationItem.largeTitleDisplayMode = .always
        router.navigationController.navigationBar.prefersLargeTitles = true

        router.setRootModule(controller)
    }

    func showSearchMentor(categoryId: String?) {
        let viewModel = SearchMentorViewModel(categoryId: categoryId)
        let controller = SearchMentorViewController(viewModel: viewModel)

        controller.didSelectMentor = { [weak self] mentorId in
            self?.showMentorProfile(mentorId: mentorId)
        }

        router.push(controller)
    }

    func showMentorProfile(mentorId: String) {
        let viewModel = MentorProfileViewModel(mentorId: mentorId)
        let controller = MentorProfileViewController(viewModel: viewModel)

        controller.didSelectClass = { [weak self] classId in
            self?.showBookingForClass(classId: classId)
        }

        controller.didTapClassesList = { [weak self] in
            self?.showClassesList(mentorId: mentorId)
        }

        router.push(controller)
    }

    func showClassesList(mentorId: String) {
        let viewModel = ClassesListViewModel(mentorId: mentorId)
        let controller = ClassesListViewController(viewModel: viewModel)

        controller.didSelectClass = { [weak self] classId in
            self?.showBookingForClass(classId: classId)
        }

        router.push(controller)
    }

    func showBookingForClass(classId: String) {
        let viewModel = BookingViewModel(classId: classId)
        let controller = BookingViewController(viewModel: viewModel)

        controller.didFinishBooking = { [weak self] in
            self?.router.popModule()
        }

        router.push(controller)
    }
}
