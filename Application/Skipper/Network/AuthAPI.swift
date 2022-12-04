//
//  AuthAPI.swift
//  Skipper
//
//  Created by Denis Kovalev on 26.11.2022.
//

import FirebaseAuth
import Foundation

protocol AuthAPI {
    func signIn(email: String, password: String) async throws -> AuthUserFirebaseModel
    func signUp(email: String, password: String) async throws -> AuthUserFirebaseModel
    func currentUser() async throws -> AuthUserFirebaseModel?
}

class FirebaseAuthAPI: AuthAPI {
    private let auth: Auth
    private

    init(auth: Auth, database: FirestoreDatabase) {
        self.auth = auth
    }

    func signIn(email: String, password: String) async throws -> AuthUserFirebaseModel {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            return AuthUserMapper.firebaseToAPI(result.user)
        } catch {
            throw mapFirebaseError(error)
        }
    }

    func signUp(email: String, password: String) async throws -> AuthUserFirebaseModel {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)

            data

            return AuthUserMapper.firebaseToAPI(result.user)
        } catch {
            throw mapFirebaseError(error)
        }
    }

    func currentUser() async throws -> AuthUserFirebaseModel? {
        auth.currentUser.flatMap(AuthUserMapper.firebaseToAPI)
    }

    // MARK: - Private

    private func mapFirebaseError(_ error: Error) -> Error {
        let error = error as NSError
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue: return FirebaseError.authInvalidEmail
        case AuthErrorCode.wrongPassword.rawValue: return FirebaseError.authInvalidPassword
        case AuthErrorCode.userDisabled.rawValue: return FirebaseError.authInvalidEmail
        case AuthErrorCode.operationNotAllowed.rawValue: return FirebaseError.authInvalidEmail
        default: return error
        }
    }
}
