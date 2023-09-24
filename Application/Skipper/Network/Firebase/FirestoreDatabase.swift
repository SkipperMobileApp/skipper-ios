//
//  FirebaseDataSource.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.12.2022.
//

import FirebaseFirestore
import Foundation

protocol FirestoreDatabase {
    func users() async throws -> [UserFirebaseModel]
    func user(userId: String) async throws -> UserFirebaseModel?
    func updateUsers(users: [UserFirebaseModel]) async throws

    func sendReport(report: ReportMentorFirebaseModel) async throws

    func lessonsForMentor(mentorId: String) async throws -> [LessonFirebaseModel]
    func lesson(lessonId: String) async throws -> LessonFirebaseModel?
    func updateLesson(lesson: LessonFirebaseModel) async throws

    func categories() async throws -> [CategoryFirebaseModel]
    func category(categoryId: String) async throws -> CategoryFirebaseModel?
}

class FirestoreDatabaseImpl: FirestoreDatabase {
    private let firestore: Firestore

    init(firestore: Firestore) {
        self.firestore = firestore
    }
}

// MARK: - Users

extension FirestoreDatabaseImpl {
    func users() async throws -> [UserFirebaseModel] {
        let query = firestore.collection("users")
        return try await get(query, type: UserFirebaseModel.self)
    }

    func user(userId: String) async throws -> UserFirebaseModel? {
        let document = firestore.collection("users").document(userId)
        return try await get(document, type: UserFirebaseModel.self)
    }

    func updateUsers(users: [UserFirebaseModel]) async throws {
        let collection = firestore.collection("users")
        try await write(models: users, to: collection)
    }
}

// MARK: - Reports

extension FirestoreDatabaseImpl {
    func sendReport(report: ReportMentorFirebaseModel) async throws {
        let collection = firestore.collection("reports")
        try await write(models: [report], to: collection)
    }
}

// MARK: - Lessons

extension FirestoreDatabaseImpl {
    func lessonsForMentor(mentorId: String) async throws -> [LessonFirebaseModel] {
        let collection = firestore.collection("lessons")
        let query = collection.whereField(
            LessonFirebaseModel.CodingKeys.mentorId.rawValue,
            isEqualTo: mentorId
        )
        return try await get(query, type: LessonFirebaseModel.self)
    }

    func lesson(lessonId: String) async throws -> LessonFirebaseModel? {
        let document = firestore.collection("lessons").document(lessonId)
        return try await get(document, type: LessonFirebaseModel.self)
    }

    func updateLesson(lesson: LessonFirebaseModel) async throws {
        let collection = firestore.collection("lessons")
        try await write(models: [lesson], to: collection)
    }
}

// MARK: - Categories

extension FirestoreDatabaseImpl {
    func categories() async throws -> [CategoryFirebaseModel] {
        let collection = firestore.collection("categories")
        return try await get(collection, type: CategoryFirebaseModel.self)
    }

    func category(categoryId: String) async throws -> CategoryFirebaseModel? {
        let document = firestore.collection("categories").document(categoryId)
        return try await get(document, type: CategoryFirebaseModel.self)
    }
}

// MARK: - Utils

extension FirestoreDatabaseImpl {
    private func get<T: FirebaseResponseModel>(
        _ documentReference: DocumentReference,
        type: T.Type
    ) async throws -> T? {
        try await withCheckedThrowingContinuation { continuation in
            documentReference.getDocument { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                if let snapshot = snapshot {
                    let result = snapshot.data().flatMap { T($0, id: snapshot.documentID) }
                    continuation.resume(returning: result)
                    return
                }

                continuation.resume(throwing: AppError(message: Strings.errorUnknown()))
            }
        }
    }

    private func get<T: FirebaseResponseModel>(_ query: Query, type: T.Type) async throws -> [T] {
        try await withCheckedThrowingContinuation { continuation in
            query.getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                if let snapshot = snapshot {
                    let result = snapshot.documents.compactMap { T($0.data(), id: $0.documentID) }
                    continuation.resume(returning: result)
                    return
                }

                continuation.resume(throwing: AppError(message: Strings.errorUnknown()))
            }
        }
    }

    private func write<T: FirebaseModel>(
        models: [T],
        to collectionReference: CollectionReference
    ) async throws {
        let batch = firestore.batch()

        models.forEach {
            batch.setData($0.toDictionary(), forDocument: collectionReference.document($0.id))
        }

        try await batch.commit()
    }

    private func write<T: FirebaseModel>(
        model: T,
        to documentReference: DocumentReference
    ) async throws {
        try await documentReference.setData(model.toDictionary())
    }
}
