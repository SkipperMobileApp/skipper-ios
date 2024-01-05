//
//  ChatModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 26.12.2023.
//

import Foundation

struct ChatModel {
    let id: String
    var lastMessage: String
    var lastUpdateDate: Date
    let opponent: UserModel
}
