//
//  ChangePasswordViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.01.2023.
//

import Foundation

class ChangePasswordViewModel {
    @Event private(set) var isLoading: Bool?
    @Event private(set) var errorEvent: Error?
    @Event private(set) var saveDataEvent: Void?

    @Injected() private var authRepository: AuthRepository

    func save(oldPassword: String, newPassword: String) {
        guard oldPassword != newPassword else {
            errorEvent = AppError(message: "Пароли не должны совпадать!")
            return
        }

        isLoading = true
        Task {
            do {
                try await authRepository.changePassword(oldPassword: oldPassword, newPassword: newPassword)

                await MainActor.run {
                    isLoading = false
                    saveDataEvent = ()
                }
            } catch {
                await MainActor.run {
                    errorEvent = error
                    isLoading = false
                }
            }
        }
    }
}
