//
//  FirebaseError.swift
//  Skipper
//
//  Created by Denis Kovalev on 26.11.2022.
//

import Foundation

enum FirebaseError: LocalizedError {
    case authInvalidEmail
    case authInvalidPassword
    case authAccountDisabled
    case firebaseSystemError
    case documentNotFound(Error?)

    var errorDescription: String? {
        switch self {
        case .authInvalidEmail:
            return Strings.errorAuthInvalidEmail()
        case .authInvalidPassword:
            return Strings.errorAuthInvalidPassword()
        case .authAccountDisabled:
            return Strings.errorAuthAccountDisabled()
        case .firebaseSystemError:
            return Strings.errorFirebaseSystem()
        case let .documentNotFound(error):
            return error?.localizedDescription ?? ""
        }
    }
}
