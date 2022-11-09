//
//  String+Extensions.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

extension String {
    /// Formats current string with `mask`.
    /// Optionally you can specify the mask `maskedCharacter` that will be considered as replacing character. Default is "*".
    ///
    /// Example: string is "123456", mask is `(***) *-*-*`, result will be "(123) 4-5-6"
    func formattedWith(mask: String, maskedCharacter: Character = "*") -> String {
        if isEmpty {
            return ""
        }

        var resultString = ""

        let source = Array(self)
        var currentSourceIndex = 0

        for maskCharacter in mask {
            if currentSourceIndex >= source.count {
                break
            }

            if maskCharacter != maskedCharacter {
                resultString.append(maskCharacter)
                continue
            }

            let sourceChar = source[currentSourceIndex]
            resultString.append(sourceChar)
            currentSourceIndex += 1
        }

        return resultString
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z.'_%+-]+@[A-Za-z0-9.'-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailTest.evaluate(with: self)
    }

    func isValidPhone() -> Bool {
        let phoneRegex = "^\\([0-9]{3}\\)[0-9]{3}\\-[0-9]{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }

    func trimmed(characters: String? = nil) -> String {
        var set = CharacterSet.whitespacesAndNewlines
        if let characters = characters {
            set.insert(charactersIn: characters)
        }
        return trimmingCharacters(in: set)
    }

    func abbreviation() -> String {
        let components = split(separator: " ").filter { !$0.isEmpty }

        if components.isEmpty {
            return ""
        }

        if components.count == 1 {
            return String(components.first!.first!)
        }

        return "\(components.first!.first!)\(components.last!.first!)"
    }

    func toBase64() -> String {
        return Data(utf8).base64EncodedString()
    }

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
