//
//  EqualValueValidator.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.12.2022.
//

import Foundation

struct EqualValueValidator: Validator {
    private let value: String
    private let errorText: String

    init(errorText: String, value: String) {
        self.errorText = errorText
        self.value = value
    }

    init(errorText: String) {
        self.errorText = errorText
        value = ""
    }

    func validate(value: String) -> String? {
        self.value == value ? nil : errorText
    }
}
