//
//  ReviewMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 13.01.2024.
//

import Foundation

enum ReviewMapper {
    static func mapAPIToDomain(_ model: ReviewFirebaseModel, author: UserModel?) -> ReviewModel {
        .init(
            id: model.id,
            userId: model.userId,
            author: author,
            text: model.text,
            rating: model.rating,
            isAnonymous: model.isAnonymous,
            date: Date(timeIntervalSince1970: TimeInterval(model.date) / 1000)
        )
    }

    static func mapRequestDomainToAPI(_ model: ReviewRequestModel) -> ReviewFirebaseModel {
        .init(
            id: UUID().uuidString,
            userId: model.targetUserId,
            authorId: model.authorId,
            rating: model.rating,
            text: model.text,
            isAnonymous: model.isAnonymous,
            date: Int(model.date.timeIntervalSince1970 * 1000)
        )
    }
}
