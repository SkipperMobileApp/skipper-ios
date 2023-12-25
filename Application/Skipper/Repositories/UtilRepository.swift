//
//  UtilRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 10.01.2023.
//

import Foundation

protocol UtilRepository {
    func categories() async throws -> [CategoryModel]
    func category(categoryId: String) async throws -> CategoryModel
}

class UtilRepositoryImpl: UtilRepository {
    private let database: FirestoreDatabase

    init(database: FirestoreDatabase) {
        self.database = database
    }
}

// MARK: - Categories

extension UtilRepositoryImpl {
    func categories() async throws -> [CategoryModel] {
        try await Task.sleep(for: .seconds(0.5))

        return try await database.categories().map(CategoryMapper.categoryFromAPIToDomain)
    }

    func category(categoryId: String) async throws -> CategoryModel {
        try await Task.sleep(for: .seconds(0.5))

        guard let category = try await database.category(categoryId: categoryId) else {
            throw AppError(message: Strings.errorCategoryNotFound())
        }

        return CategoryMapper.categoryFromAPIToDomain(category)
    }
}
