//
//  AuthRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.11.2022.
//

import Foundation

protocol AuthRepository {
    func signIn(email: String, password: String) async throws -> AuthUserModel

    func currentUser() async throws -> AuthUserModel?
}

class AuthRepositoryImpl: AuthRepository {
    private let api: AuthAPI

    init(api: AuthAPI) {
        self.api = api
    }

    func signIn(email: String, password: String) async throws -> AuthUserModel {
        let result = try await api.signIn(email: email, password: password)
        return AuthUserMapper.apiToDomain(result)
    }

    func currentUser() async throws -> AuthUserModel? {
        try await api.currentUser().flatMap(AuthUserMapper.apiToDomain)
    }
}
