//
//  AppDelegate.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Alamofire
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
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
        let firestore = Firestore.firestore()

        // Cache

        let authCache = AuthCacheImpl()

        // Database

        let firestoreDatabase = FirestoreDatabaseImpl(firestore: firestore)

        // API

        let tokensContainer: TokensContainer = KeychainContainer()
        let authAPI = FirebaseAuthAPI(auth: auth, database: firestoreDatabase)

        // Repositories

        let authRepositoryImpl = AuthRepositoryImpl(api: authAPI, cache: authCache)
        let authRepository: AuthRepository = authRepositoryImpl
        let logoutRepository: LogoutRepository = authRepositoryImpl
        let lessonRepository: LessonRepository = LessonRepositoryImpl()
        let utilRepository: UtilRepository = UtilRepositoryImpl()
        let userRepository: UserRepository = UserRepositoryImpl(
            lessonRepository: lessonRepository,
            utilRepository: utilRepository
        )
        let bookedLessonRepository: BookedLessonRepository = BookedLessonRepositoryImpl()

        // Services

        let logoutHandler = makeLogoutHandler(logoutRepository: logoutRepository,
                                              postLogoutNavigationHandler: reAuthHandler)

        // Assembling

        SharedDependencyContainer.register(logoutHandler)
        SharedDependencyContainer.register(tokensContainer)
        SharedDependencyContainer.register(authRepository)
        SharedDependencyContainer.register(utilRepository)
        SharedDependencyContainer.register(lessonRepository)
        SharedDependencyContainer.register(userRepository)
        SharedDependencyContainer.register(bookedLessonRepository)
    }

    private func makeLogoutHandler(logoutRepository: LogoutRepository,
                                   postLogoutNavigationHandler: @escaping () -> Void) -> LogoutHandler
    {
        SyncCompositeLogoutHandler {
            APILogoutHandler(logoutRepository: logoutRepository)
            NavigationLogoutHandler(logoutNavigationHandler: postLogoutNavigationHandler)
        }
    }
}
