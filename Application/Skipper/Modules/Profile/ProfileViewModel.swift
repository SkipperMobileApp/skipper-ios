//
//  ProfileViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Foundation
import UIKit

class ProfileViewModel {
    // MARK: - Injected

    @Injected() private var logoutHandler: LogoutHandler
    @Injected() private var userRepository: UserRepository
    @Injected() private var authRepository: AuthRepository

    // MARK: - Properties

    @Event private(set) var isLoading: Bool?
    @Event private(set) var errorEvent: Error?

    @Published private(set) var profileInfo: ProfileInfo = .init(
        name: "--",
        avatarUrl: nil,
        email: "--"
    )

    // MARK: - API Calls

    func loadData() {
        Task {
            do {
                guard let currentUser = try await authRepository.currentUser(forceUpdate: false) else {
                    throw AppError(message: "Ошибка авторизации")
                }

                let user = try await userRepository.user(userId: currentUser.id)

                await MainActor.run {
                    profileInfo = .init(
                        name: [user.lastName, user.firstName].filter { !$0.isEmpty }.joined(separator: " "),
                        avatarUrl: user.imageUrl,
                        email: user.email
                    )
                }
            } catch {
                await MainActor.run {
                    errorEvent = error
                }
            }
        }
    }

    func deleteAccount() {}

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
                    errorEvent = error
                    isLoading = false
                }
            }
        }
    }

    private func updateAvatarImage(image: UIImage?) {
        isLoading = true

        Task {
            do {
                guard let image = image else {
                    throw AppError(message: "Что-то пошло не так")
                }

                guard let imageData = image.jpegData(compressionQuality: 0.6) else {
                    throw AppError(message: "Что-то пошло не так")
                }

                guard let currentUser = try await authRepository.currentUser(forceUpdate: false) else {
                    throw AppError(message: "Ошибка авторизации")
                }

                var user = try await userRepository.user(userId: currentUser.id)

                let url = try await userRepository.uploadUserImage(
                    userImage: .init(
                        userId: currentUser.id,
                        data: imageData
                    )
                )

                user.imageUrl = url.absoluteString

                try await userRepository.updateUser(user: user)

                await MainActor.run {
                    profileInfo.avatarUrl = url.absoluteString
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorEvent = error
                    isLoading = false
                }
            }
        }
    }

    // MARK: - Data Methods

    func imageActionProvider(for type: ImagePickerProvider.`Type`) -> ImagePickerProvider {
        .init(type: type) { [weak self] image in
            self?.updateAvatarImage(image: image)
        }
    }
}

// MARK: - View Model

extension ProfileViewModel {
    struct ProfileInfo {
        let name: String
        var avatarUrl: String?
        let email: String
    }

    enum Option: CaseIterable {
        case info, password, notifications

        var title: String {
            switch self {
            case .info: return "Личная информация"
            case .password: return "Управление паролем"
            case .notifications: return "Параметры уведомлений"
            }
        }

        var icon: UIImage {
            switch self {
            case .info: return R.icon.profileCircle
            case .password: return R.icon.lockCircle
            case .notifications: return R.icon.bellCircle
            }
        }
    }
}
