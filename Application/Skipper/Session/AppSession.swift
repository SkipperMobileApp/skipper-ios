//
//  AppSession.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

class AppSession {
    let tokensContainer: TokensContainer
    let exampleRepository: ExampleRepository

    init(tokensContainer: TokensContainer,
         exampleRepository: ExampleRepository)
    {
        self.tokensContainer = tokensContainer
        self.exampleRepository = exampleRepository
    }
}
