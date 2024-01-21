//
//  ReviewRequestModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 16.01.2024.
//

import Foundation

struct ReviewRequestModel {
    let targetUserId: String
    let authorId: String
    let date: Date
    let text: String
    let isAnonymous: Bool
    let rating: Double
}
