//
//  FirebaseDataSource.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.12.2022.
//

import Combine
import FirebaseFirestore
import Foundation

protocol FirestoreDatabase {
    func users() async throws -> [UserFirebaseModel]
    func users(userIds: [String]) async throws -> [UserFirebaseModel]
    func user(userId: String) async throws -> UserFirebaseModel?
    func updateUsers(users: [UserFirebaseModel]) async throws

    func sendReport(report: ReportMentorFirebaseModel) async throws

    func lessonsForMentor(mentorId: String) async throws -> [LessonFirebaseModel]
    func lesson(lessonId: String) async throws -> LessonFirebaseModel?
    func updateLesson(lesson: LessonFirebaseModel) async throws

    func categories() async throws -> [CategoryFirebaseModel]
    func category(categoryId: String) async throws -> CategoryFirebaseModel?

    func bookLessons(lessons: [BookedLessonFirebaseModel]) async throws
    func bookedLessonsForUser(userId: String) async throws -> [BookedLessonFirebaseModel]
    func bookedLesson(bookedLessonId: String) async throws -> BookedLessonFirebaseModel?
    func cancelBookedLesson(bookedLessonId: String) async throws

    func chats(userId: String) async throws -> [ChatFirebaseModel]
    func chat(chatId: String) async throws -> ChatFirebaseModel?
    func setChat(chat: ChatFirebaseModel) async throws
    func subscribeOnChats(userId: String) -> AnyPublisher<[ChatFirebaseModel], Error>

    func messages(for chatId: String) async throws -> [ChatMessageFirebaseModel]
    func setMessage(message: ChatMessageFirebaseModel) async throws
    func subscribeOnMessages(chatId: String) -> AnyPublisher<[ChatMessageFirebaseModel], Error>
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

    func users(userIds: [String]) async throws -> [UserFirebaseModel] {
        let query = firestore
            .collection("users")
            .whereField(FieldPath.documentID(), in: userIds)

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
        let query = firestore.collection("lessons").whereField(
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

// MARK: - BookedLessons

extension FirestoreDatabaseImpl {
    func bookLessons(lessons: [BookedLessonFirebaseModel]) async throws {
        let collection = firestore.collection("booked_lessons")
        try await write(models: lessons, to: collection)
    }

    func bookedLesson(bookedLessonId: String) async throws -> BookedLessonFirebaseModel? {
        let document = firestore.collection("booked_lessons").document(bookedLessonId)
        return try await get(document, type: BookedLessonFirebaseModel.self)
    }

    func bookedLessonsForUser(userId: String) async throws -> [BookedLessonFirebaseModel] {
        let query = firestore.collection("booked_lessons").whereField(
            BookedLessonFirebaseModel.CodingKeys.userId.rawValue,
            isEqualTo: userId
        )

        return try await get(query, type: BookedLessonFirebaseModel.self)
    }

    func cancelBookedLesson(bookedLessonId: String) async throws {
        let document = firestore.collection("booked_lessons").document(bookedLessonId)
        try await document.delete()
    }
}

// MARK: - Chat

extension FirestoreDatabaseImpl {
    func chats(userId: String) async throws -> [ChatFirebaseModel] {
        let query = firestore
            .collection("dialogs")
            .whereField(ChatFirebaseModel.CodingKeys.participants.rawValue, arrayContains: userId)

        return try await get(query, type: ChatFirebaseModel.self)
    }

    func chat(chatId: String) async throws -> ChatFirebaseModel? {
        let document = firestore.collection("dialogs").document(chatId)

        return try await get(document, type: ChatFirebaseModel.self)
    }

    func setChat(chat: ChatFirebaseModel) async throws {
        let document = firestore.collection("dialogs").document(chat.id)

        try await write(model: chat, to: document)
    }

    func subscribeOnChats(userId: String) -> AnyPublisher<[ChatFirebaseModel], Error> {
        let query = firestore
            .collection("dialogs")
            .whereField(ChatFirebaseModel.CodingKeys.participants.rawValue, arrayContains: userId)

        return subscribe(query, type: ChatFirebaseModel.self)
    }

    func messages(for chatId: String) async throws -> [ChatMessageFirebaseModel] {
        let collection = firestore
            .collection("dialogs")
            .document(chatId)
            .collection("messages")

        return try await get(collection, type: ChatMessageFirebaseModel.self)
    }

    func setMessage(message: ChatMessageFirebaseModel) async throws {
        let document = firestore
            .collection("dialogs")
            .document(message.chatId)
            .collection("messages")
            .document(message.id)

        try await write(model: message, to: document)
    }

    func subscribeOnMessages(chatId: String) -> AnyPublisher<[ChatMessageFirebaseModel], Error> {
        let collection = firestore
            .collection("dialogs")
            .document(chatId)
            .collection("messages")

        return subscribe(collection, type: ChatMessageFirebaseModel.self)
    }
}

// MARK: - Utils

extension FirestoreDatabaseImpl {
    private func get<T: FirebaseResponseModel>(
        _ documentReference: DocumentReference,
        type: T.Type
    ) async throws -> T? {
        let snapshot = try await documentReference.getDocument()
        return snapshot.data().flatMap { T($0, id: snapshot.documentID) }
    }

    private func get<T: FirebaseResponseModel>(_ query: Query, type: T.Type) async throws -> [T] {
        let snapshots = try await query.getDocuments()
        return snapshots.documents.compactMap { T($0.data(), id: $0.documentID) }
    }

    private func get<T: FirebaseResponseModel>(
        _ collection: CollectionReference,
        type: T.Type
    ) async throws -> [T] {
        let snapshots = try await collection.getDocuments()
        return snapshots.documents.compactMap { T($0.data(), id: $0.documentID) }
    }

    private func subscribe<T: FirebaseResponseModel>(
        _ query: Query,
        type: T.Type
    ) -> AnyPublisher<[T], Error> {
        let subject = PassthroughSubject<[T], Error>()
        let listener = query.addSnapshotListener { documentSnapshot, error in
            if let error {
                subject.send(completion: .failure(error))
                return
            }

            guard let documentSnapshot else {
                subject.send(completion: .failure(FirebaseError.documentNotFound(error)))
                return
            }

            let models = documentSnapshot
                .documents
                .compactMap { T($0.data(), id: $0.documentID) }

            subject.send(models)
        }

        return subject
            .handleEvents(receiveCancel: {
                listener.remove()
            })
            .eraseToAnyPublisher()
    }

    private func subscribe<T: FirebaseResponseModel>(
        _ collection: CollectionReference,
        type: T.Type
    ) -> AnyPublisher<[T], Error> {
        let subject = PassthroughSubject<[T], Error>()
        let listener = collection.addSnapshotListener { documentSnapshot, error in
            if let error {
                subject.send(completion: .failure(error))
                return
            }

            guard let documentSnapshot else {
                subject.send(completion: .failure(FirebaseError.documentNotFound(error)))
                return
            }

            let models = documentSnapshot
                .documents
                .compactMap { T($0.data(), id: $0.documentID) }

            subject.send(models)
        }

        return subject
            .handleEvents(receiveCancel: {
                listener.remove()
            })
            .eraseToAnyPublisher()
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
