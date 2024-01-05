//
//  ChatMessageModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 26.12.2023.
//

import Foundation

struct ChatMessageModel {
    let id: String
    let senderId: String
    let chatId: String
    let type: ChatMessageType
    let content: String
    let date: Date
}
