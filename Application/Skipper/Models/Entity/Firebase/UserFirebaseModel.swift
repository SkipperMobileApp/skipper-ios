//
//  UserFirebaseModel.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 19.11.2022.
//

import Foundation

struct UserFirebaseModel: FirebaseModel {
    let id: String
    let email: String

    let firstName: String
    let lastName: String
    let patronymic: String
    let bio: String

    let post: String
    let branch: String

    let imageURL: String?

    enum CodingKeys: String {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case patronymic
        case bio
        case post
        case branch
        case imageURL = "image_url"
    }

    init(id: String,
         email: String,
         firstName: String,
         lastName: String,
         patronymic: String,
         bio: String,
         post: String,
         branch: String,
         imageURL: String? = nil)
    {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.patronymic = patronymic
        self.bio = bio
        self.post = post
        self.branch = branch
        self.imageURL = imageURL
    }

    init?(_ dict: [String: Any], id: String) {
        guard let email = dict[CodingKeys.email.rawValue] as? String,
              let firstName = dict[CodingKeys.firstName.rawValue] as? String,
              let lastName = dict[CodingKeys.lastName.rawValue] as? String,
              let patronymic = dict[CodingKeys.patronymic.rawValue] as? String,
              let bio = dict[CodingKeys.bio.rawValue] as? String,
              let post = dict[CodingKeys.post.rawValue] as? String,
              let branch = dict[CodingKeys.branch.rawValue] as? String else { return nil }

        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.patronymic = patronymic
        self.bio = bio
        self.post = post
        self.branch = branch
        imageURL = dict[CodingKeys.imageURL.rawValue] as? String
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.email.rawValue: email,
            CodingKeys.firstName.rawValue: firstName,
            CodingKeys.lastName.rawValue: lastName,
            CodingKeys.patronymic.rawValue: patronymic,
            CodingKeys.bio.rawValue: bio,
            CodingKeys.post.rawValue: post,
            CodingKeys.branch.rawValue: branch,
            CodingKeys.imageURL.rawValue: imageURL as Any
        ]
    }
}

typealias PaginatedUserFirebaseModel = PaginatedModel<UserFirebaseModel>
