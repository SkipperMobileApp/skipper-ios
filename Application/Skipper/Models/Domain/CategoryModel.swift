//
//  CategoryModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 10.01.2023.
//

import UIKit

struct CategoryModel {
    let id: String
    let name: String
    let image: UIImage
    let subcategories: [Subcategory]
}

extension CategoryModel {
    struct Subcategory {
        let name: String
    }
}
