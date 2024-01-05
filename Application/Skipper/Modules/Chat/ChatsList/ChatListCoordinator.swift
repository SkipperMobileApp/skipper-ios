//
//  ChatListCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2024.
//

import Foundation

class ChatListCoordinator: NavigationCoordinator {
    var didSelectChat: ((_ chatId: String, _ opponentId: String) -> Void)?

    // MARK: - Initialization

    override init(with router: NavigationRouter) {
        super.init(with: router)

        let viewModel = ChatsListViewModel()
        let controller = ChatsListViewController(viewModel: viewModel)

        controller.didSelectChat = { [weak self] chatId, opponentId in
            self?.didSelectChat?(chatId, opponentId)
        }

        router.navigationController.navigationItem.largeTitleDisplayMode = .always
        router.navigationController.navigationBar.prefersLargeTitles = true

        router.setRootModule(controller)
    }
}
