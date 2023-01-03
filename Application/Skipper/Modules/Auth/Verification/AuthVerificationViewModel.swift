//
//  AuthVerificationViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 29.12.2022.
//

import Foundation

class AuthVerificationViewModel {
    // MARK: - Output

    var didResendEmail: (() -> Void)?
    var didFail: ((Error) -> Void)?

    // MARK: - Properties

    @Injected() private var authRepository: AuthRepository

    // MARK: - API Calls

    func resendVerificationEmail() {
        Task {
            do {
                try await authRepository.resendVerificationEmail()
                await MainActor.run {
                    didResendEmail?()
                }
            } catch {
                await MainActor.run {
                    didFail?(error)
                }
            }
        }
    }
}
