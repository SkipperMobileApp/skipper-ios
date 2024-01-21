//
//  ReviewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 13.01.2024.
//

import Foundation

struct ReviewModel {
    let id: String
    let userId: String
    let author: UserModel?
    let text: String?
    let rating: Double
    let isAnonymous: Bool
    let date: Date
}
