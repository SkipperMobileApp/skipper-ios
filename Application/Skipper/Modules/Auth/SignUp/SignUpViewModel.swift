//
//  SignUpViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 28.11.2022.
//

import Foundation

class SignUpViewModel {
    // MARK: - API Calls

    func signUp() {}

    func validate(values: [Field: String]) -> [Field: [String]] {
        values.reduce(into: [Field: [String]]()) { result, element in
            let errors = element.key.validators.compactMap { $0.validate(value: element.value) }
            result[element.key] = errors.isEmpty ? nil : errors
        }
    }
}

extension SignUpViewModel {
    enum Field: CaseIterable {
        case lastName
        case firstName
        case patronymic
        case email
        case password
        case confirmPassword

        var placeholderText: String {
            switch self {
            case .lastName: return Strings.authSignUpLastNamePlaceholder()
            case .firstName: return Strings.authSignUpFirstNamePlaceholder()
            case .patronymic: return Strings.authSignUpPatronymicPlaceholder()
            case .email: return Strings.authSignUpEmailPlaceholder()
            case .password: return Strings.authSignUpPasswordPlaceholder()
            case .confirmPassword: return Strings.authSignUpConfirmPasswordPlaceholder()
            }
        }

        var fieldStyle: FormFieldView.Style {
            switch self {
            case .lastName: return .text
            case .firstName: return .text
            case .patronymic: return .text
            case .email: return .email
            case .password: return .password
            case .confirmPassword: return .password
            }
        }

        var validators: [Validator] {
            switch self {
            case .email:
                return [
                    EmptyValueValidator(errorText: Strings.authLoginErrorEmailEmpty()),
                    EmailValidator(errorText: Strings.authLoginErrorEmailIncorrect())
                ]
            case .password:
                return [
                    EmptyValueValidator(errorText: Strings.authLoginErrorPasswordEmpty())
                ]
            }
        }
    }
}
