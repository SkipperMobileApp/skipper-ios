//
//  LoginViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Combine
import FirebaseAuth

class LoginViewModel {
    // MARK: - Outputs

    @MainActor var didLogin: (() -> Void)?
    @MainActor var didFail: ((Error) -> Void)?

    // MARK: - Properties

    @Injected() private var authRepository: AuthRepository

    // MARK: - API Calls

    func login(email: String, password: String) {
        Task {
            do {
                let user = try await authRepository.signIn(email: email, password: password)
                await MainActor.run {
                    didLogin?()
                }
            } catch {
                await MainActor.run {
                    didFail?(error)
                }
            }
        }
    }

    func validate(values: [Field: String]) -> [Field: [String]] {
        values.reduce(into: [Field: [String]]()) { result, element in
            let errors = element.key.validators.compactMap { $0.validate(value: element.value) }
            result[element.key] = errors.isEmpty ? nil : errors
        }
    }
}

extension LoginViewModel {
    typealias FieldStyle = FormFieldView.Style

    enum Field: CaseIterable {
        case email, password

        var fieldStyle: FieldStyle {
            switch self {
            case .password: return .password
            case .email: return .email
            }
        }

        var placeholderText: String {
            switch self {
            case .email: return Strings.authLoginEmailPlaceholder()
            case .password: return Strings.authLoginPasswordPlaceholder()
            }
        }

        var validators: [Validator] {
            switch self {
            case .email:
                return [
                    EmailValidator(errorText: Strings.authErrorEmailIncorrect())
                ]
            case .password:
                return [
                    EmptyValueValidator(errorText: Strings.authErrorPasswordEmpty())
                ]
            }
        }
    }
}
