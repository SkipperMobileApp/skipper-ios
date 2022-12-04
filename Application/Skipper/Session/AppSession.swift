//
//  AppSession.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

class AppSession {
    let tokensContainer: TokensContainer
    let authRepository: AuthRepository
    let userService: UserService

    init(tokensContainer: TokensContainer,
         authRepository: AuthRepository,
         userService: UserService)
    {
        self.tokensContainer = tokensContainer
        self.authRepository = authRepository
        self.userService = userService
    }
}
