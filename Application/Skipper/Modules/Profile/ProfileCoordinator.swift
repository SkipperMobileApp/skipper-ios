//
//  ProfileCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Foundation

class ProfileCoordinator: NavigationCoordinator {
    private let imagePicker = ImagePicker()

    override init(with router: NavigationRouter) {
        super.init(with: router)

        let viewModel = ProfileViewModel()
        let controller = ProfileViewController(viewModel: viewModel)

        controller.didTapEditProfileInfo = { [weak self] in
            self?.showEditPersonalInfo()
        }

        controller.didTapEditPassword = { [weak self] in
            self?.showEditPassword()
        }

        controller.didTapEditNotifications = { [weak self] in
        }

        controller.didTapLessonsManagement = { [weak self] in
            self?.showLessonManagement()
        }

        controller.didTapImageAction = { [weak self, weak controller] provider in
            guard let self = self, let controller = controller else { return }
            self.imagePicker.presentPicker(provider: provider, on: controller)
        }

        router.navigationController.navigationItem.largeTitleDisplayMode = .always
        router.navigationController.navigationBar.prefersLargeTitles = true

        router.setRootModule(controller)
    }

    private func showEditPersonalInfo() {
        let viewModel = EditPersonalInfoViewModel()
        let controller = EditPersonalInfoViewController(viewModel: viewModel)

        router.push(controller)
    }

    private func showEditPassword() {
        let viewModel = ChangePasswordViewModel()
        let controller = ChangePasswordViewController(viewModel: viewModel)

        router.push(controller)
    }

    private func showEditNotifications() {}

    private func showLessonManagement() {
        let coordinator = LessonManagementCoordinator(with: router)

        coordinator.didFinish = { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }

        addChild(coordinator)
    }
}
