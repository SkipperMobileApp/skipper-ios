//
//  AsyncCompositeLogoutHandler.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.12.2022.
//

import Foundation

class AsyncCompositeLogoutHandler: CompositeLogoutHandler {
    private let handlers: [LogoutHandler]

    required init(@LogoutHandlerComposed handlerBuilder: () -> [LogoutHandler]) {
        handlers = handlerBuilder()
    }

    func logout() async throws {
        try await handlers.asyncForEach {
            try await $0.logout()
        }
    }
}
