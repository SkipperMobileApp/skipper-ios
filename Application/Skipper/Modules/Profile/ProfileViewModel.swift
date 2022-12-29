//
//  ProfileViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Foundation

class ProfileViewModel {
    // MARK: - Injected

    @Injected() private var logoutHandler: LogoutHandler

    // MARK: - Properties

    @Event private(set) var isLoading: Bool?
    @Event private(set) var failEvent: Error?

    // MARK: - API Calls

    func logout() {
        isLoading = true
        Task {
            do {
                try await logoutHandler.logout()

                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    failEvent = error
                    isLoading = false
                }
            }
        }
    }
}
