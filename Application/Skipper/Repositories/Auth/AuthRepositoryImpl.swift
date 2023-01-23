//
//  AuthRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.11.2022.
//

import Foundation

class AuthRepositoryImpl: AuthRepository, LogoutRepository {
    private let api: AuthAPI
    private let cache: AuthCache

    init(api: AuthAPI, cache: AuthCache) {
        self.api = api
        self.cache = cache
    }

    func signIn(email: String, password: String) async throws -> AuthUserModel {
        let result = try await api.signIn(email: email, password: password)
        let user = AuthUserMapper.apiToDomain(result)

        cache.currentUser = AuthUserMapper.domainToCache(user)

        return user
    }

    func signUp(user: UserRegisterModel) async throws -> AuthUserModel {
        let result = try await api.signUp(user: UserRegisterMapper.domainToAPI(user))
        let user = AuthUserMapper.apiToDomain(result)

        cache.currentUser = AuthUserMapper.domainToCache(user)

        return user
    }

    func signOut() async throws {
        try await api.signOut()
        cache.clear()
    }

    func currentUser(forceUpdate: Bool = false) async throws -> AuthUserModel? {
        if !forceUpdate, let cachedUser = cache.currentUser {
            return AuthUserMapper.cacheToDomain(cachedUser)
        }

        return try await api.currentUser().flatMap(AuthUserMapper.apiToDomain)
    }

    func resendVerificationEmail() async throws {
        try await api.resendVerificationEmail()
    }

    func changePassword(oldPassword: String, newPassword: String) async throws {
        try await api.changePassword(oldPassword: oldPassword, newPassword: newPassword)
    }

    func changeEmail(email: String) async throws {
        try await api.changeEmail(email: email)
    }
}
