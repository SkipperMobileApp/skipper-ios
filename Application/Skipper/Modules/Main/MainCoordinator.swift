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

    // MARK: - Tabs

    private func initTabs() -> [TabBox] {
        let dashboardCoordinator = DashboardCoordinator(with: NavigationRouter())
        let profileCoordinator = ProfileCoordinator(with: NavigationRouter())
        let myLessonsCoordinator = MyLessonsCoordinator(with: NavigationRouter())

        return [
            (.dashboard, dashboardCoordinator),
            (.myLessons, myLessonsCoordinator),
            (.profile, profileCoordinator)
        ]
    }

    private func addTabs(_ tabs: [TabBox], to tabController: UITabBarController, selectedTab: Tab = .dashboard) {
        let sorted = tabs.sorted { box1, box2 -> Bool in
            box2.tab.rawValue > box1.tab.rawValue
        }

        let controllers = sorted.map { box -> UIViewController in
            self.tabs[box.tab] = box.coordinator
            let controller = box.coordinator.toPresentable()
            controller.tabBarItem = UITabBarItem(title: box.tab.title, image: box.tab.icon, tag: box.tab.rawValue)
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
        case .profile: return "Профиль"
        }
    }

    var icon: UIImage? {
        switch self {
        case .dashboard: return R.icon.home
        case .myLessons: return R.icon.checklist
        case .profile: return R.icon.profile
        }
    }
}
