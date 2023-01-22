//
//  CategoryModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 10.01.2023.
//

import Foundation

struct CategoryModel {
    let id: String
    let name: String
    let imageUrl: String?
    let subcategories: [Subcategory]
}

extension CategoryModel {
    struct Subcategory {
        let name: String
    }
}
