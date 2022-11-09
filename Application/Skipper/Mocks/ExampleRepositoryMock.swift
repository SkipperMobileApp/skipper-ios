//
//  ExampleRepositoryMock.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

class ExampleRepositoryMock: ExampleRepository {
    func getRemote() async throws -> [ExampleModel] {
        [.init(id: "1", value: "1")]
    }

    func getLocal() throws -> [ExampleModel] {
        [.init(id: "1", value: "1")]
    }
}
