//
//  UserImageMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.01.2023.
//

import Foundation

enum UserImageMapper {
    static func uploadDomainToAPI(_ model: UserImageUploadModel) -> UserImageStorageModel {
        .init(userId: model.userId, data: model.data)
    }
}
