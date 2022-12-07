//
//  CharacterSet+Extensions.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.12.2022.
//

import Foundation

extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        return character.unicodeScalars.allSatisfy(contains)
    }
}

extension CharacterSet {
    static let specialSymbols = CharacterSet(charactersIn: #"!@#$%^&*()[]{}<>,.\|/?_+-=`~;:'""#)
}
