//
//  ChatRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 26.12.2023.
//

import Combine
import Foundation

protocol ChatRepository {
    func getChats(userId: String) async throws -> [ChatModel]
    func getChat(chatId: String, userId: String) async throws -> ChatModel?
    func saveChat(chat: ChatModel, userId: String) async throws
    func getChatWithOpponent(userId: String, opponentId: String) async throws -> ChatModel?
    func subscribeOnChats(userId: String) -> AnyPublisher<[ChatModel], Error>

    func getMessages(for chatId: String) async throws -> [ChatMessageModel]
    func sendMessage(message: ChatMessageModel) async throws
    func uploadMessageImage(model: ChatMessageImageUploadModel) async throws -> URL
    func subscribeOnMessages(chatId: String) -> AnyPublisher<[ChatMessageModel], Error>
}

class ChatRepositoryImpl: ChatRepository {
    private let database: FirestoreDatabase
    private let storage: StorageDatabase

    init(database: FirestoreDatabase, storage: StorageDatabase) {
        self.database = database
        self.storage = storage
    }

    func getChats(userId: String) async throws -> [ChatModel] {
        let chats = try await database.chats(userId: userId)

        return try await chats.asyncCompactMap { chat -> (ChatFirebaseModel, UserFirebaseModel)? in
            guard let id = chat.participants.first(where: { $0 != userId }) else {
                return nil
            }

            guard let user = try await self.database.user(userId: id) else {
                return nil
            }

            return (chat, user)
        }.map {
            let user = UserMapper.apiToDomain($0.1)
            return ChatMapper.chatFirebaseToDomain($0.0, userModel: user)
        }
    }

    func getChat(chatId: String, userId: String) async throws -> ChatModel? {
        guard let chat = try await database.chat(chatId: chatId),
              let opponentId = chat.participants.first(where: { $0 != userId }),
              let user = try await database.user(userId: opponentId)
        else {
            return nil
        }

        return ChatMapper.chatFirebaseToDomain(chat, userModel: UserMapper.apiToDomain(user))
    }

    func getChatWithOpponent(userId: String, opponentId: String) async throws -> ChatModel? {
        guard let user = try await database.user(userId: opponentId),
              let chat = try await database.chat(userId: userId, opponentId: opponentId)
        else {
            return nil
        }

        return ChatMapper.chatFirebaseToDomain(chat, userModel: UserMapper.apiToDomain(user))
    }

    func saveChat(chat: ChatModel, userId: String) async throws {
        let model = ChatMapper.chatDomainToFirebase(chat, currentUserId: userId)
        try await database.setChat(chat: model)
    }

    func subscribeOnChats(userId: String) -> AnyPublisher<[ChatModel], Error> {
        database.subscribeOnChats(userId: userId)
            .flatMap { [weak self] chats -> AnyPublisher<
                [(ChatFirebaseModel, UserFirebaseModel)],
                Error
            > in
                guard let self else {
                    return Fail<[(ChatFirebaseModel, UserFirebaseModel)], Error>(
                        error: AppError(message: "Unknown error")
                    ).eraseToAnyPublisher()
                }

                return self.getUsersForChats(currentUserId: userId, chats: chats)
            }
            .map { chatsAndUsers in
                chatsAndUsers
                    .map {
                        let user = UserMapper.apiToDomain($0.1)
                        return ChatMapper.chatFirebaseToDomain($0.0, userModel: user)
                    }
            }
            .eraseToAnyPublisher()
    }

    func getMessages(for chatId: String) async throws -> [ChatMessageModel] {
        try await database.messages(for: chatId).map(ChatMapper.messageFirebaseToDomain)
    }

    func sendMessage(message: ChatMessageModel) async throws {
        let model = ChatMapper.messageDomainToFirebase(message)
        try await database.setMessage(message: model)
    }

    func uploadMessageImage(model: ChatMessageImageUploadModel) async throws -> URL {
        let model = ChatMessageImageMapper.domainToAPI(model)

        return try await storage.uploadChatImage(model: model)
    }

    func subscribeOnMessages(chatId: String) -> AnyPublisher<[ChatMessageModel], Error> {
        database.subscribeOnMessages(chatId: chatId)
            .map { messages in
                messages
                    .map(ChatMapper.messageFirebaseToDomain)
                    .sorted { $0.date < $1.date }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private

    private func getUsersForChats(
        currentUserId: String,
        chats: [ChatFirebaseModel]
    ) -> AnyPublisher<[(ChatFirebaseModel, UserFirebaseModel)], Error> {
        return Future<[(ChatFirebaseModel, UserFirebaseModel)], Error> { [weak self] promise in
            guard let self else { return }
            Task {
                do {
                    let chatsWithOpponentIds = chats
                        .compactMap { chat -> (ChatFirebaseModel, String)? in
                            guard let id = chat.participants.first(where: { $0 != currentUserId })
                            else {
                                return nil
                            }

                            return (chat, id)
                        }

                    let users = try await self.database
                        .users(userIds: chatsWithOpponentIds.map { $0.1 })

                    let result = users
                        .compactMap { user -> (ChatFirebaseModel, UserFirebaseModel)? in
                            guard let chat = chatsWithOpponentIds.first(where: { $0.1 == user.id })
                            else {
                                return nil
                            }

                            return (chat.0, user)
                        }

                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
