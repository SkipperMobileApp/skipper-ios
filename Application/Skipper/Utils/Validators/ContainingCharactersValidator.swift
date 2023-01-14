//
//  ContainingCharactersValidator.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.12.2022.
//

import Foundation

struct ContainingCharactersValidator: Validator {
    private let errorText: String
    private let allowedCharacters: CharacterSet
    private let minimumAmount: Int

    init(errorText: String, allowedCharacters: CharacterSet, minimumAmount: Int) {
        self.errorText = errorText
        self.allowedCharacters = allowedCharacters
        self.minimumAmount = minimumAmount
    }

    init(errorText: String) {
        self.errorText = errorText
        minimumAmount = 0
        allowedCharacters = []
    }

    func validate(value: String) -> String? {
        let filteredValue = value.filter { allowedCharacters.contains($0) }
        // print("\(String(describing: self)) - value: \(value) - filtering: \(filteredValue) - result: \(filteredValue.count >= minimumAmount)")
        return filteredValue.count >= minimumAmount ? nil : errorText
    }
}
