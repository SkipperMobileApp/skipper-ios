//
//  EditPersonalInfoViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 22.01.2023.
//

class EditPersonalInfoViewModel {
    @Event private(set) var isLoading: Bool?
    @Event private(set) var errorEvent: Error?
    @Event private(set) var saveDataEvent: Void?
    @Event private(set) var personalInfoEvent: PersonalInfo?

    @Injected() private var userRepository: UserRepository
    @Injected() private var authRepository: AuthRepository

    func loadData() {
        Task {
            do {
                guard let authUser = try await authRepository.currentUser(forceUpdate: false) else {
                    throw AppError(message: Strings.errorUserNotAuthorized())
                }

                let user = try await userRepository.user(userId: authUser.id)

                await MainActor.run {
                    personalInfoEvent = .init(
                        firstName: user.firstName,
                        lastName: user.lastName,
                        email: user.email,
                        post: user.post,
                        bio: user.bio
                    )

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

    func save(firstName: String, lastName: String, email: String, post: String, bio: String) {
        isLoading = true
        Task {
            do {
                guard let authUser = try await authRepository.currentUser(forceUpdate: false) else {
                    throw AppError(message: Strings.errorUserNotAuthorized())
                }

//                if authUser.email != email {
//                    try await authRepository.changeEmail(email: email)
//                }

                var user = try await userRepository.user(userId: authUser.id)

                user.firstName = firstName
                user.lastName = lastName
                user.email = email
                user.post = post
                user.bio = bio

                try await userRepository.updateUser(user: user)

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

extension EditPersonalInfoViewModel {
    struct PersonalInfo {
        let firstName: String
        let lastName: String
        let email: String
        let post: String
        let bio: String
    }
}
