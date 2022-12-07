//
//  Validator.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 13.11.2022.
//

import Foundation

protocol Validator {
    init(errorText: String)

    func validate(value: String) -> String?
}
