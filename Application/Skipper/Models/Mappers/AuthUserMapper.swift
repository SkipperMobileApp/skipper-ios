//
//  AuthUserMapper.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 12.11.2022.
//

import FirebaseAuth
import Foundation

enum AuthUserMapper {
    static func firebaseToAPI(_ model: User) -> AuthUserFirebaseModel {
        .init(id: model.uid, email: model.email ?? "")
    }

    static func apiToDomain(_ model: AuthUserFirebaseModel) -> AuthUserModel {
        .init(id: model.id, email: model.email)
    }

    static func cacheToDomain(_ model: AuthUserCacheModel) -> AuthUserModel {
        .init(id: model.id, email: model.email)
    }

    static func domainToCache(_ model: AuthUserModel) -> AuthUserCacheModel {
        .init(id: model.id, email: model.email)
    }
}
