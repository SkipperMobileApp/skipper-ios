//
//  UserModel.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 19.11.2022.
//

import Foundation

struct UserModel {
    var id: String
    let email: String

    let firstName: String
    let lastName: String
    let patronymic: String
    let bio: String

    let post: String
    let branch: String

    let imageURL: String?
}

typealias PaginatedUserModel = PaginatedModel<UserModel>
