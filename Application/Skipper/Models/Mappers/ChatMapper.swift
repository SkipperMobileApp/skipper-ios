//
//  ChatMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 26.12.2023.
//

import Foundation

enum ChatMapper {
    static func chatFirebaseToDomain(
        _ model: ChatFirebaseModel,
        userModel: UserModel
    ) -> ChatModel {
        .init(
            id: model.id,
            lastMessage: model.lastMessage,
            lastUpdateDate: Date(
                timeIntervalSince1970: TimeInterval(model.lastUpdateDate) / 1000.0
            ),
            opponent: userModel
        )
    }

    static func chatDomainToFirebase(
        _ model: ChatModel,
        currentUserId: String
    ) -> ChatFirebaseModel {
        .init(
            id: model.id,
            lastMessage: model.lastMessage,
            lastUpdateDate: Int(model.lastUpdateDate.timeIntervalSince1970 * 1000),
            participants: [currentUserId, model.opponent.id]
        )
    }

    static func messageFirebaseToDomain(_ model: ChatMessageFirebaseModel) -> ChatMessageModel {
        .init(
            id: model.id,
            senderId: model.senderId,
            chatId: model.chatId,
            type: messageTypeToDomain(model.type),
            content: model.content,
            date: Date(timeIntervalSince1970: TimeInterval(model.date / 1000))
        )
    }

    static func messageDomainToFirebase(_ model: ChatMessageModel) -> ChatMessageFirebaseModel {
        .init(
            id: model.id,
            chatId: model.chatId,
            senderId: model.senderId,
            type: messageTypeToAPI(model.type),
            content: model.content,
            date: Int(model.date.timeIntervalSince1970 * 1000)
        )
    }

    static func messageTypeToDomain(_ type: String) -> ChatMessageType {
        switch type {
        case "image": return .image
        case "text": return .text
        default: return .unknown
        }
    }

    static func messageTypeToAPI(_ type: ChatMessageType) -> String {
        switch type {
        case .image: return "image"
        case .text: return "text"
        case .unknown: return "unknown"
        }
    }
}
