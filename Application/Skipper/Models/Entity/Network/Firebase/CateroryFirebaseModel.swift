//
//  CateroryFirebaseModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 24.09.2023.
//

import Foundation

struct CategoryFirebaseModel {
    let id: String
    let name: String
    let key: String
    let subcategories: [String]

    init(id: String, name: String, key: String, subcategories: [String]) {
        self.id = id
        self.name = name
        self.key = key
        self.subcategories = subcategories
    }
}

extension CategoryFirebaseModel: FirebaseResponseModel {
    private enum CodingKeys: String {
        case id
        case name
        case key
        case subcategories
    }

    init?(_ dict: [String: Any], id: String) {
        guard let name = dict[CodingKeys.name.rawValue] as? String,
              let key = dict[CodingKeys.key.rawValue] as? String,
              let subcategories = dict[CodingKeys.subcategories.rawValue] as? [String]
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.key = key
        self.subcategories = subcategories
    }
}
