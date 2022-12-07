//
//  SignUpViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 28.11.2022.
//

import Foundation

class SignUpViewModel {
    // MARK: - Output

    @MainActor var didSignUp: (() -> Void)?
    @MainActor var didFail: ((Error) -> Void)?

    // MARK: - Properties

    @Injected() private var authRepository: AuthRepository

    // MARK: - API Calls

    func signUp(values: [Field: String]) {
        Task {
            do {
                guard let userModel = registerModel(from: values) else {
                    throw AppError(message: Strings.errorUnknown())
                }

                let user = try await authRepository.signUp(user: userModel)

                await MainActor.run {
                    didSignUp?()
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

    // MARK: - Utils

    private func registerModel(from values: [Field: String]) -> UserRegisterModel? {
        guard let email = values[.email],
              let password = values[.password],
              let firstName = values[.firstName],
              let lastName = values[.lastName] else { return nil }

        return .init(email: email,
                     password: password,
                     firstName: firstName,
                     lastName: lastName)
    }
}

extension SignUpViewModel {
    enum Field: CaseIterable {
        case lastName
        case firstName
        case email
        case password

        var placeholderText: String {
            switch self {
            case .lastName: return Strings.authSignUpLastNamePlaceholder()
            case .firstName: return Strings.authSignUpFirstNamePlaceholder()
            case .email: return Strings.authSignUpEmailPlaceholder()
            case .password: return Strings.authSignUpPasswordPlaceholder()
            }
        }

        var fieldStyle: FormFieldView.Style {
            switch self {
            case .lastName: return .text
            case .firstName: return .text
            case .email: return .email
            case .password: return .password
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
                    EmptyValueValidator(errorText: Strings.authErrorPasswordEmpty()),
                    LengthValidator(errorText: Strings.authErrorPasswordLength(8),
                                    minimumLength: 8),
                    ContainingCharactersValidator(errorText: Strings.authErrorPasswordUppercase(1),
                                                  allowedCharacters: .uppercaseLetters,
                                                  minimumAmount: 1),
                    ContainingCharactersValidator(errorText: Strings.authErrorPasswordLowercase(1),
                                                  allowedCharacters: .lowercaseLetters,
                                                  minimumAmount: 1),
                    ContainingCharactersValidator(errorText: Strings.authErrorPasswordDigit(1),
                                                  allowedCharacters: .decimalDigits,
                                                  minimumAmount: 1),
                    ContainingCharactersValidator(errorText: Strings.authErrorPasswordSymbol(1),
                                                  allowedCharacters: .specialSymbols,
                                                  minimumAmount: 1)
                ]
            case .firstName:
                return [EmptyValueValidator(errorText: Strings.authErrorFirstNameEmpty())]
            case .lastName:
                return [EmptyValueValidator(errorText: Strings.authErrorLastNameEmpty())]
            }
        }
    }
}
