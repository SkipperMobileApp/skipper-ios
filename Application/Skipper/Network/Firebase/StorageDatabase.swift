//
//  StorageDatabase.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.01.2023.
//

import FirebaseStorage
import Foundation

protocol StorageDatabase {
    func uploadImage(model: UserImageStorageModel) async throws -> URL
    func deleteImage(userId: String) async throws
}

class StorageDatabaseImpl: StorageDatabase {
    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    func uploadImage(model: UserImageStorageModel) async throws -> URL {
        try? await deleteImage(userId: model.userId)

        let reference = storage.reference().child("avatars").child("\(model.userId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await reference.putDataAsync(model.data, metadata: metadata)

        return try await reference.downloadURL()
    }

    func deleteImage(userId: String) async throws {
        let reference = storage.reference().child("avatars").child("\(userId).jpg")

        try await reference.delete()
    }
}
