//
//  SplashViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

class SplashViewModel {
    var didFinish: ((_ isSuccess: Bool) -> Void)?

    @Injected() private var authRepository: AuthRepository

    func tryLogin() {
        Task {
            do {
                try await Task.sleep(nanoseconds: 1000000000)

                let user = try await authRepository.currentUser(forceUpdate: true)

                await MainActor.run {
                    didFinish?(user?.isVerified ?? false)
                }
            } catch {
                Log.error(error.localizedDescription)
                await MainActor.run {
                    didFinish?(false)
                }
            }
        }
    }
}
