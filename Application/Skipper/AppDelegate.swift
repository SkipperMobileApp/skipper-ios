//
//  AppDelegate.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Alamofire
import FirebaseAuth
import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        initializeDependencyGraph(reAuthHandler: { [weak self] in
            self?.appCoordinator.runAuth()
        })

        window = UIWindow()

        let coordinator = AppCoordinator(with: AppRouter(with: window!))
        coordinator.start()

        appCoordinator = coordinator

        return true
    }

    private func initializeDependencyGraph(reAuthHandler: @escaping () -> Void) {
        // Firebase

        let auth = Auth.auth()

        // Database

        let database = Database()

        // TODO: Example, remove when another database DAO is ready
        let exampleDao = ExampleDaoImpl(context: database.context)

        // API

        let tokensContainer: TokensContainer = KeychainContainer()
        let authAPI = FirebaseAuthAPI(auth: auth)

        // Repositories

        let authRepository: AuthRepository = AuthRepositoryImpl(api: authAPI)

        // Services

        let userService: UserService = UserServiceImpl()

        // Registration

        SharedDependencyContainer.register(tokensContainer)
        SharedDependencyContainer.register(authRepository)
        SharedDependencyContainer.register(userService)
    }
}
