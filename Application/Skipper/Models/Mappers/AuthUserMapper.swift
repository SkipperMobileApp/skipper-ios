//
//  AuthUserMapper.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 12.11.2022.
//

import FirebaseAuth
import Foundation

enum AuthUserMapper {
    static func firebaseToAPI(_ user: User) -> AuthUserFirebaseModel {
        .init(id: user.uid, email: user.email ?? "")
    }

    static func apiToDomain(_ user: AuthUserFirebaseModel) -> AuthUserModel {
        .init(id: user.id, email: user.email)
    }
}
