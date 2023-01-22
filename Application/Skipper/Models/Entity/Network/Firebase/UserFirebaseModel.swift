//
//  UserFirebaseModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 19.11.2022.
//

import Foundation

struct UserFirebaseModel: FirebaseModel {
    let id: String
    let email: String

    let firstName: String
    let lastName: String
    let post: String
    let bio: String

    let imageUrl: String?

    enum CodingKeys: String {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case post
        case imageUrl = "image_url"
    }

    init(
        id: String,
        email: String,
        firstName: String,
        lastName: String,
        bio: String,
        post: String,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.post = post
        self.imageUrl = imageUrl
    }

    init?(_ dict: [String: Any], id: String) {
        guard let email = dict[CodingKeys.email.rawValue] as? String,
              let firstName = dict[CodingKeys.firstName.rawValue] as? String,
              let lastName = dict[CodingKeys.lastName.rawValue] as? String,
              let bio = dict[CodingKeys.bio.rawValue] as? String,
              let post = dict[CodingKeys.post.rawValue] as? String else { return nil }

        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.post = post
        imageUrl = dict[CodingKeys.imageUrl.rawValue] as? String
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.email.rawValue: email,
            CodingKeys.firstName.rawValue: firstName,
            CodingKeys.lastName.rawValue: lastName,
            CodingKeys.bio.rawValue: bio,
            CodingKeys.post.rawValue: post,
            CodingKeys.imageUrl.rawValue: imageUrl ?? NSNull()
        ]
    }
}

typealias PaginatedUserFirebaseModel = PaginatedModel<UserFirebaseModel>
