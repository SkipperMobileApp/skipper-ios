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

    private func showSearchMentor(categoryId: String?) {
        let viewModel = SearchMentorViewModel(categoryId: categoryId)
        let controller = SearchMentorViewController(viewModel: viewModel)

        controller.didSelectMentor = { [weak self] mentorId in
            self?.showMentorProfile(mentorId: mentorId)
        }

        router.push(controller)
    }

    private func showMentorProfile(mentorId: String) {
        let coordinator = MentorProfileCoordinator(with: router, mentorId: mentorId)

        addChild(coordinator)

        coordinator.didFinish = { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }
}
