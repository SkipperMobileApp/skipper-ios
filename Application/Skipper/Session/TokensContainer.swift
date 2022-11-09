//
//  TokensContainer.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import KeychainAccess

protocol TokensContainer: AnyObject {
    var tokens: TokensModel? { get }

    func save(tokens: TokensModel)
    func update(newTokens: TokensModel)
    func removeTokens()
}

/// Keychain container to keep secrets in sync.
class KeychainContainer: TokensContainer {
    private enum Keys {
        static let tokens = "tokens"
    }

    private let keychain: Keychain

    private(set) var tokens: TokensModel?
    private(set) var connecTAdminPassword: String?

    init(service: String = Bundle.main.bundleIdentifier!) {
        keychain = Keychain(service: service)
            .synchronizable(false)
            .accessibility(.afterFirstUnlock)

        tokens = read(key: Keys.tokens)
    }

    /// Saves tokens into the keychain.
    func save(tokens: TokensModel) {
        self.tokens = tokens
        write(key: Keys.tokens, value: tokens)
    }

    /// Updates tokens in the keychain with new tokens.
    func update(newTokens: TokensModel) {
        save(tokens: newTokens)
    }

    /// Removes auth tokens.
    func removeTokens() {
        tokens = nil
        try? keychain.remove(Keys.tokens)
    }
}

// MARK: - Utils

extension KeychainContainer {
    private func read<T: Decodable>(key: String, type: T.Type = T.self) -> T? {
        guard let data = try? keychain.getData(key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            Log.error("KeychainContainer: Failed to decode \(type), \(error)")
            return nil
        }
    }

    private func write<T: Encodable>(key: String, value: T) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        do {
            try keychain.set(data, key: key)
        } catch {
            Log.error("KeychainContainer: Failed to save \(key), \(error)")
        }
    }
}
