//
//  EmailValidator.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 13.11.2022.
//

import Foundation

struct EmailValidator: Validator {
    private let errorText: String

    init(errorText: String) {
        self.errorText = errorText
    }

    func validate(value: String) -> String? {
        value.isValidEmail() ? nil : errorText
    }
}
