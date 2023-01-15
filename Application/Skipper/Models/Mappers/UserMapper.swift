//
//  UserMapper.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 19.11.2022.
//

import Foundation

enum UserMapper {
    static func apiToDomain(_ model: UserFirebaseModel) -> UserModel {
        .init(
            id: model.id,
            email: model.email,
            firstName: model.firstName,
            lastName: model.lastName,
            patronymic: model.patronymic,
            bio: model.bio,
            post: model.post,
            imageURL: model.imageURL,
            isMentor: false,
            contacts: [],
            stats: .init(lessonsCount: 0, rating: 0, registrationDate: "", reviewsCount: 0),
            tags: [],
            lessons: [],
            resumeInfo: .init(educationUnits: [], workUnits: [], achievementUnits: [])
        )
    }

    static func domainToAPI(_ model: UserModel) -> UserFirebaseModel {
        .init(id: model.id,
              email: model.email,
              firstName: model.firstName,
              lastName: model.lastName,
              patronymic: model.patronymic,
              bio: model.bio,
              post: model.post,
              branch: model.post)
    }
}
