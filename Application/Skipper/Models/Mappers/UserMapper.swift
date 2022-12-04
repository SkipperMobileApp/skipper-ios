//
//  UserMapper.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 19.11.2022.
//

import Foundation

enum UserMapper {
    static func apiToDomain(_ model: UserFirebaseModel) -> UserModel {
        .init(id: model.id,
              email: model.email,
              firstName: model.firstName,
              lastName: model.lastName,
              patronymic: model.patronymic,
              bio: model.bio,
              post: model.post,
              branch: model.branch,
              imageURL: model.imageURL)
    }

    static func domainToAPI(_ model: UserModel) -> UserFirebaseModel {
        .init(id: model.id,
              email: model.email,
              firstName: model.firstName,
              lastName: model.lastName,
              patronymic: model.patronymic,
              bio: model.bio,
              post: model.post,
              branch: model.branch)
    }
}
