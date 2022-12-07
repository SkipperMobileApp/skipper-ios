//
//  MainViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

class MainViewModel {
    @Injected() private var authRepository: AuthRepository
    @Injected() private var logoutHandler: LogoutHandler

    @MainActor var didFail: ((Error) -> Void)?

    func signOut() {
        Task {
            do {
                try await logoutHandler.logout()

            } catch {
                await MainActor.run {
                    didFail?(error)
                }
            }
        }
    }
}
