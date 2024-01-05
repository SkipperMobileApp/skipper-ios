//
//  ChatMessageFirebaseModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 26.12.2023.
//

import Foundation

struct ChatMessageFirebaseModel {
    let id: String
    let chatId: String
    let senderId: String
    let type: String
    let content: String
    let date: Int

    init(id: String, chatId: String, senderId: String, type: String, content: String, date: Int) {
        self.id = id
        self.chatId = chatId
        self.senderId = senderId
        self.type = type
        self.content = content
        self.date = date
    }
}

extension ChatMessageFirebaseModel: FirebaseModel {
    enum CodingKeys: String {
        case chatId = "chat_id"
        case senderId = "sender_id"
        case type
        case content
        case date
    }

    init?(_ dict: [String: Any], id: String) {
        guard let chatId = dict[CodingKeys.chatId.rawValue] as? String,
              let senderId = dict[CodingKeys.senderId.rawValue] as? String,
              let type = dict[CodingKeys.type.rawValue] as? String,
              let content = dict[CodingKeys.content.rawValue] as? String,
              let date = dict[CodingKeys.date.rawValue] as? Int
        else {
            return nil
        }

        self.id = id
        self.chatId = chatId
        self.senderId = senderId
        self.type = type
        self.content = content
        self.date = date
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.chatId.rawValue: chatId,
            CodingKeys.senderId.rawValue: senderId,
            CodingKeys.type.rawValue: type,
            CodingKeys.content.rawValue: content,
            CodingKeys.date.rawValue: date
        ]
    }
}
