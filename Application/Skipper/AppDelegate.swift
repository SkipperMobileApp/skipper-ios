//
//  AppDelegate.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Alamofire
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let session = makeAppSession(reAuthHandler: { [weak self] in
            self?.appCoordinator.runAuth()
        })

        window = UIWindow()

        let coordinator = AppCoordinator(with: AppRouter(with: window!), session: session)
        coordinator.start()

        appCoordinator = coordinator

        return true
    }

    private func makeAppSession(reAuthHandler: @escaping () -> Void) -> AppSession {
        // Database

        let database = Database()

        // TODO: Example, remove when another database DAO is ready
        let exampleDao = ExampleDaoImpl(context: database.context)

        // API

        let tokensContainer = KeychainContainer()

        var monitors: [EventMonitor] = []
        monitors.append(APILogger()) // Uncomment if you want to see network logs in your debug session
        let session = Session(eventMonitors: monitors)

        let reachability = RemoteNetworkReachability()

        let api = API(interceptor: APIRequestIntercepter(tokensContainer: tokensContainer,
                                                         refreshTokenFailureHandler: { [weak tokensContainer] in
                                                             tokensContainer?.removeTokens()
                                                             reAuthHandler()
                                                         }),
                      session: session,
                      reachability: reachability)

        // Repositories

        // TODO: Example, remove when another database repository is ready
        let exampleRepository = ExampleRepositoryImpl(api: api,
                                                      database: database,
                                                      exampleDao: exampleDao)

        // Assembling

        return AppSession(tokensContainer: tokensContainer,
                          exampleRepository: exampleRepository)
    }
}
