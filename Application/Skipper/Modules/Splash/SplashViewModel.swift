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
    @Injected() private var userService: UserService

    func tryLogin() {
        Task {
            do {
                try await Task.sleep(nanoseconds: 1000000000)

                let user = try await authRepository.currentUser()

                await MainActor.run {
                    if let user = user {
                        userService.currentUser = user
                    }

                    didFinish?(userService.isAuthenticated)
                }
            } catch {
                await MainActor.run {
                    Log.error(error.localizedDescription)
                    didFinish?(false)
                }
            }
        }
    }
}
