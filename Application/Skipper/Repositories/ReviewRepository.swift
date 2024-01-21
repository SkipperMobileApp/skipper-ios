//
//  ReviewRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 13.01.2024.
//

import Foundation

protocol ReviewRepository {
    func getReviews(targetUserId: String) async throws -> [ReviewModel]
    func sendReview(model: ReviewRequestModel) async throws
}

class ReviewRepositoryImpl {
    private let database: FirestoreDatabase

    init(database: FirestoreDatabase) {
        self.database = database
    }
}

// MARK: - ReviewRepository

extension ReviewRepositoryImpl: ReviewRepository {
    func getReviews(targetUserId: String) async throws -> [ReviewModel] {
        let reviews = try await database.reviews(for: targetUserId)

        return try await reviews.asyncCompactMap { review in
            var author: UserModel?
            if !review.isAnonymous {
                author = try await self.database.user(
                    userId: review.authorId
                ).flatMap(UserMapper.apiToDomain)
            }
            return ReviewMapper.mapAPIToDomain(review, author: author)
        }
    }

    func sendReview(model: ReviewRequestModel) async throws {
        try await database.setReview(review: ReviewMapper.mapRequestDomainToAPI(model))
    }
}
