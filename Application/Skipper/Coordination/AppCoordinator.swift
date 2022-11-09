import SwiftUI
import UIKit

/// Root coordinator for the app
class AppCoordinator: RootCoordinator {
    /// Describes possible modules which can be root module of the app
    enum RootModule {
        case main, auth, splash
    }

    // MARK: - Properties

    private var deeplink: DeepLink?
    private(set) var currentRootModule: RootModule?

    // MARK: - Initialization

    override func start(with deeplink: DeepLink?) {
        self.deeplink = deeplink
        runSplash()
    }

    func clear() {
        childCoordinators.removeAll()
    }

    // MARK: - Root Flows

    private func runSplash() {
        clear()

        let viewModel = SplashViewModel(session: session)
        let controller = SplashViewController(viewModel: viewModel)

        controller.didFinish = { [weak self] isSuccess in
            isSuccess ? self?.runMain() : self?.runAuth()
        }

        router.setRootModule(controller, transitionOptions: defaultTransitionOptions)
        currentRootModule = .splash
    }

    func runAuth() {
        clear()

        let viewModel = AuthViewModel(session: session)
        let controller = AuthViewController(viewModel: viewModel)

        controller.didFinish = { [weak self] in
            self?.runMain()
        }

        router.setRootModule(controller, transitionOptions: defaultTransitionOptions)
        currentRootModule = .auth
    }

    private func runMain() {
        if currentRootModule == .main { return }

        clear()

        let coordinator = MainCoordinator(with: NavigationRouter(), session: session)

        coordinator.didFinish = { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }

        addChild(coordinator)

        router.setRootModule(coordinator.toPresentable(),
                             transitionOptions: defaultTransitionOptions)
        currentRootModule = .main
    }
}

private let defaultTransitionOptions = UIWindow.TransitionOptions(direction: .fade, style: .easeIn)
