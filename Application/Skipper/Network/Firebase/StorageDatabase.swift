//
//  StorageDatabase.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.01.2023.
//

import FirebaseStorage
import Foundation

protocol StorageDatabase {
    func uploadUserImage(model: UserImageStorageModel) async throws -> URL
    func deleteUserImage(userId: String) async throws

    func uploadChatImage(model: ChatMessageImageStorageModel) async throws -> URL
    func deleteChatImage(chatId: String, imageName: String) async throws
}

class StorageDatabaseImpl: StorageDatabase {
    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }
}

// MARK: - User Images

extension StorageDatabaseImpl {
    func uploadUserImage(model: UserImageStorageModel) async throws -> URL {
        try? await deleteUserImage(userId: model.userId)

        let reference = storage.reference().child("avatars").child("\(model.userId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await reference.putDataAsync(model.data, metadata: metadata)

        return try await reference.downloadURL()
    }

    func deleteUserImage(userId: String) async throws {
        let reference = storage.reference().child("avatars").child("\(userId).jpg")

        try await reference.delete()
    }
}

// MARK: - Chat Images

extension StorageDatabaseImpl {
    func uploadChatImage(model: ChatMessageImageStorageModel) async throws -> URL {
        let reference = storage
            .reference()
            .child("chats")
            .child(model.chatId)
            .child("\(model.imageName).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await reference.putDataAsync(model.data, metadata: metadata)

        return try await reference.downloadURL()
    }

    func deleteChatImage(chatId: String, imageName: String) async throws {
        let reference = storage.reference().child("chats").child(chatId).child("\(imageName).jpg")

        try await reference.delete()
    }
}
