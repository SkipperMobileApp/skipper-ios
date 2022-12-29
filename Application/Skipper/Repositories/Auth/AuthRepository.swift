//
//  AuthRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.12.2022.
//

import Foundation

protocol AuthRepository {
    func signIn(email: String, password: String) async throws -> AuthUserModel
    func signUp(user: UserRegisterModel) async throws -> AuthUserModel

    func resendVerificationEmail() async throws

    func currentUser(forceUpdate: Bool) async throws -> AuthUserModel?
}

extension AuthRepository {
    func currentUser(forceUpdate: Bool = false) async throws -> AuthUserModel? {
        try await currentUser(forceUpdate: forceUpdate)
    }
}
