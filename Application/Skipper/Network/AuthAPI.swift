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
    func signUp(user: UserRegisterAPIModel) async throws -> AuthUserFirebaseModel
    func signOut() async throws

    func resendVerificationEmail() async throws

    func currentUser() async throws -> AuthUserFirebaseModel?

    func changePassword(oldPassword: String, newPassword: String) async throws
    func changeEmail(email: String) async throws
}

class FirebaseAuthAPI: AuthAPI {
    private let auth: Auth
    private let database: FirestoreDatabase

    init(auth: Auth, database: FirestoreDatabase) {
        self.auth = auth
        self.database = database
    }

    func signIn(email: String, password: String) async throws -> AuthUserFirebaseModel {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            return AuthUserMapper.firebaseToAPI(result.user)
        } catch {
            throw mapFirebaseError(error)
        }
    }

    func signUp(user: UserRegisterAPIModel) async throws -> AuthUserFirebaseModel {
        do {
            let result = try await auth.createUser(withEmail: user.email,
                                                   password: user.password)

            let authUser = AuthUserMapper.firebaseToAPI(result.user)

            let user = UserFirebaseModel(id: authUser.id,
                                         email: authUser.email,
                                         firstName: user.firstName,
                                         lastName: user.lastName,
                                         bio: "",
                                         post: "",
                                         imageUrl: nil)

            try await database.updateUsers(users: [user])

            return authUser
        } catch {
            throw mapFirebaseError(error)
        }
    }

    func signOut() async throws {
        try auth.signOut()
    }

    func resendVerificationEmail() async throws {
        try await auth.currentUser?.sendEmailVerification()
    }

    func currentUser() async throws -> AuthUserFirebaseModel? {
        auth.currentUser.flatMap(AuthUserMapper.firebaseToAPI)
    }

    func changePassword(oldPassword: String, newPassword: String) async throws {
        guard let user = auth.currentUser, let email = user.email else {
            throw AppError(message: "Пользователь не вошел в аккаунт")
        }

        try await user.reauthenticate(with: EmailAuthProvider.credential(
            withEmail: email,
            password: oldPassword
        )
        )

        try await user.updatePassword(to: newPassword)
    }

    func changeEmail(email: String) async throws {
        try await auth.currentUser?.updateEmail(to: email)
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
