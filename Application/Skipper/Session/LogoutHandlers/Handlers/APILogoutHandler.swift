//
//  APILogoutHandler.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.12.2022.
//

import Foundation

class APILogoutHandler: LogoutHandler {
    private let logoutRepository: LogoutRepository

    init(logoutRepository: LogoutRepository) {
        self.logoutRepository = logoutRepository
    }

    func logout() async throws {
        try? await logoutRepository.signOut()
    }
}
