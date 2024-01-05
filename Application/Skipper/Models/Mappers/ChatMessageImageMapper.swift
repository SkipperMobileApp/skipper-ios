//
//  ChatMessageImageMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2024.
//

import Foundation

enum ChatMessageImageMapper {
    static func domainToAPI(_ model: ChatMessageImageUploadModel) -> ChatMessageImageStorageModel {
        .init(chatId: model.chatId, imageName: model.imageName, data: model.data)
    }
}
