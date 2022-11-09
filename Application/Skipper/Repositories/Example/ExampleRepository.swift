//
//  ExampleRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

protocol ExampleRepository {
    func getRemote() async throws -> [ExampleModel]

    func getLocal() throws -> [ExampleModel]
}

class ExampleRepositoryImpl: ExampleRepository {
    private let api: API
    private let database: Database
    private let exampleDao: ExampleDao

    init(api: API, database: Database, exampleDao: ExampleDao) {
        self.api = api
        self.database = database
        self.exampleDao = exampleDao
    }

    func getRemote() async throws -> [ExampleModel] {
        let request = ExampleAPIRouter.getExamples
        let result = try await api.request(request, type: [ExampleAPIModel].self)
        return result.map(ExampleMapper.apiToDomain)
    }

    func getLocal() throws -> [ExampleModel] {
        let result = try exampleDao.getExamples()
        return result.map(ExampleMapper.dbToDomain)
    }
}
