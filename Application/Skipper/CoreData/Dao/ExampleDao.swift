//
//  ExampleDao.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import CoreData
import Foundation

// TODO: Example, remove when another database DAO is ready
protocol ExampleDao {
    func getExamples() throws -> [ExampleDBModel]
}

class ExampleDaoImpl: ExampleDao {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getExamples() throws -> [ExampleDBModel] {
        let request = ExampleDBModel.fetchRequest()
        request.fetchLimit = 100
        return try context.fetch(request)
    }
}
