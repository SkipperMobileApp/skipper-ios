//
//  NavigationLogoutHandler.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.12.2022.
//

import Foundation

class NavigationLogoutHandler: LogoutHandler {
    private let handler: () -> Void

    init(logoutNavigationHandler: @escaping () -> Void) {
        handler = logoutNavigationHandler
    }

    func logout() async throws {
        await MainActor.run {
            handler()
        }
    }
}
