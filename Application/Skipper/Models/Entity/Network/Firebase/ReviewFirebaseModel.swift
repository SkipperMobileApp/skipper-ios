//
//  ReviewFirebaseModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 13.01.2024.
//

import Foundation

struct ReviewFirebaseModel {
    let id: String
    let userId: String
    let authorId: String
    let rating: Double
    let text: String?
    let isAnonymous: Bool
    let date: Int

    init(
        id: String,
        userId: String,
        authorId: String,
        rating: Double,
        text: String?,
        isAnonymous: Bool,
        date: Int
    ) {
        self.id = id
        self.userId = userId
        self.authorId = authorId
        self.rating = rating
        self.text = text
        self.isAnonymous = isAnonymous
        self.date = date
    }
}

extension ReviewFirebaseModel: FirebaseModel {
    enum CodingKeys: String {
        case userId = "user_id"
        case authorId = "author_id"
        case rating
        case text
        case isAnonymous = "is_anonymous"
        case date
    }

    init?(_ dict: [String: Any], id: String) {
        guard let userId = dict[CodingKeys.userId.rawValue] as? String,
              let authorId = dict[CodingKeys.authorId.rawValue] as? String,
              let rating = dict[CodingKeys.rating.rawValue] as? Double,
              let isAnonymous = dict[CodingKeys.isAnonymous.rawValue] as? Bool,
              let date = dict[CodingKeys.date.rawValue] as? Int
        else {
            return nil
        }

        self.id = id
        self.userId = userId
        self.authorId = authorId
        self.rating = rating
        text = dict[CodingKeys.text.rawValue] as? String
        self.isAnonymous = isAnonymous
        self.date = date
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.userId.rawValue: userId,
            CodingKeys.authorId.rawValue: authorId,
            CodingKeys.rating.rawValue: rating,
            CodingKeys.text.rawValue: text ?? NSNull(),
            CodingKeys.isAnonymous.rawValue: isAnonymous,
            CodingKeys.date.rawValue: date
        ]
    }
}
