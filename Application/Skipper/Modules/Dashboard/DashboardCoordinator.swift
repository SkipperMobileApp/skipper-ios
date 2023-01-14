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

        controller.didSelectMentor = { [weak self] mentorId in
            self?.showMentorProfile(mentorId: mentorId)
        }

        router.push(controller)
    }

    func showMentorProfile(mentorId: String) {
        let viewModel = MentorProfileViewModel(mentorId: mentorId)
        let controller = MentorProfileViewController(viewModel: viewModel)

        controller.didSelectClass = { [weak self] _ in
        }

        controller.didTapClassesList = { [weak self] in
            self?.showClassesList(mentorId: mentorId)
        }

        router.push(controller)
    }

    func showClassesList(mentorId: String) {
        let viewModel = ClassesListViewModel(mentorId: mentorId)
        let controller = ClassesListViewController(viewModel: viewModel)

        router.push(controller)
    }
}
