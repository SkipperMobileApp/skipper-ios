//
//  MainCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import UIKit

class MainCoordinator: NavigationCoordinator {
    // MARK: - Definitions

    typealias TabBox = (tab: Tab, coordinator: NavigationCoordinator)
    typealias Tab = MainTabBarViewController.Tab

    // MARK: - Output

    var didFinish: (() -> Void)?

    // MARK: - Properties

    private var tabs: [Tab: NavigationCoordinator] = [:]

    private let tabController: MainTabBarViewController

    // MARK: - Initialization

    override init(with router: NavigationRouter) {
        let viewModel = MainTabBarViewModel()
        let controller = MainTabBarViewController(viewModel: viewModel)

        tabController = controller

        super.init(with: router)

        controller.didFinish = { [weak self] in
            self?.didFinish?()
        }

        router.navigationController.setNavigationBarHidden(true, animated: false)

        addTabs(initTabs(), to: controller)
        router.setRootModule(controller)
    }

    // MARK: - Routing

    private func showChat(chatId: String, opponentId: String) {
        let coordinator = ChatCoordinator(with: router, chatId: chatId, opponentId: opponentId)

        coordinator.didFinish = { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }

        addChild(coordinator)
    }

    // MARK: - Tabs

    private func initTabs() -> [TabBox] {
        let showChatCallback: ((String, String) -> Void)? = { [weak self] chatId, opponentId in
            self?.showChat(chatId: chatId, opponentId: opponentId)
        }

        let dashboardCoordinator = DashboardCoordinator(with: NavigationRouter())
        let profileCoordinator = ProfileCoordinator(with: NavigationRouter())

        let myLessonsCoordinator = MyLessonsCoordinator(with: NavigationRouter())
        myLessonsCoordinator.didTapOpenChat = showChatCallback

        let chatCoordinator = ChatListCoordinator(with: NavigationRouter())
        chatCoordinator.didSelectChat = showChatCallback

        return [
            (.dashboard, dashboardCoordinator),
            (.myLessons, myLessonsCoordinator),
            (.chats, chatCoordinator),
            (.profile, profileCoordinator)
        ]
    }

    private func addTabs(
        _ tabs: [TabBox],
        to tabController: UITabBarController,
        selectedTab: Tab = .dashboard
    ) {
        let sorted = tabs.sorted { box1, box2 -> Bool in
            box2.tab.rawValue > box1.tab.rawValue
        }

        let controllers = sorted.map { box -> UIViewController in
            self.tabs[box.tab] = box.coordinator
            let controller = box.coordinator.toPresentable()
            let item = UITabBarItem(
                title: box.tab.title,
                image: box.tab.icon,
                tag: box.tab.rawValue
            )

            item.selectedImage = box.tab.selectedIcon

            controller.tabBarItem = item
            return controller
        }

        tabController.viewControllers = controllers
        tabController.selectedIndex = selectedTab.rawValue
    }
}

// MARK: - Tab Items

private extension MainCoordinator.Tab {
    var title: String {
        switch self {
        case .dashboard: return "Главная"
        case .myLessons: return "Мои занятия"
        case .chats: return "Чаты"
        case .profile: return "Профиль"
        }
    }

    var icon: UIImage? {
        switch self {
        case .dashboard: return R.icon.home
        case .myLessons: return R.icon.checklist
        case .chats: return R.icon.chat
        case .profile: return R.icon.profile
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .chats: return R.icon.chatFill
        default: return nil
        }
    }
}
