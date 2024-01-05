//
//  ChatViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 01.01.2024.
//

import Combine
import Foundation
import UIKit

class ChatViewModel {
    @Injected() private var chatRepository: ChatRepository
    @Injected() private var authRepository: AuthRepository
    @Injected() private var userRepository: UserRepository

    @Event private(set) var errorEvent: Error?
    @Event private(set) var isLoading: Bool?
    @Event private(set) var messagesUpdatedEvent: Void?
    @Event private(set) var isSendingMessageEvent: Bool?
    @Event private(set) var messageSentEvent: Void?
    @Event private(set) var imageSentEvent: Void?

    @Published private(set) var userViewModel: UserViewModel = .init(
        name: Strings.chatChatMessagesDefaultOpponentName(),
        avatarURL: nil
    )

    private(set) var messages: [(HeaderItem, [MessageItem])] = []

    private var messagesSubscription: AnyCancellable?

    private let chatId: String
    private let opponentId: String
    private var currentUserId: String?
    private var chat: ChatModel?

    init(chatId: String, opponentId: String) {
        self.chatId = chatId
        self.opponentId = opponentId
    }

    func loadMessages() {
        isLoading = true
        Task {
            do {
                guard let userId = try await authRepository.currentUser(forceUpdate: false)?.id,
                      let chat = try await chatRepository.getChat(chatId: chatId, userId: userId)
                else {
                    return
                }

                self.chat = chat

                currentUserId = userId

                let opponent = try await userRepository.user(userId: opponentId)

                userViewModel = .init(
                    name: [opponent.firstName, opponent.lastName].joined(separator: " "),
                    avatarURL: opponent.imageUrl
                )

                messagesSubscription?.cancel()
                messagesSubscription = chatRepository
                    .subscribeOnMessages(chatId: chatId)
                    .map {
                        $0.sorted { $0.date > $1.date }
                    }
                    .sink(receiveCompletion: { [weak self] completion in
                        if case let .failure(error) = completion {
                            self?.errorEvent = error
                            self?.isLoading = false
                        }
                    }, receiveValue: { [weak self] messages in
                        guard let self else { return }

                        self.messages = self.groupMessagesToItemsWithSections(
                            messages: messages,
                            currentUserId: userId
                        )

                        self.messagesUpdatedEvent = ()

                        self.isLoading = false
                    })

            } catch {
                errorEvent = error
                isLoading = false
            }
        }
    }

    func sendMessage(text: String) {
        guard let currentUserId, let chat else { return }

        isSendingMessageEvent = true

        Task {
            let date = Date.now

            let messageModel = ChatMessageModel(
                id: UUID().uuidString,
                senderId: currentUserId,
                chatId: chatId,
                type: .text,
                content: text,
                date: date
            )

            let chatModel = ChatModel(
                id: chat.id,
                lastMessage: text,
                lastUpdateDate: date,
                opponent: chat.opponent
            )

            do {
                try await chatRepository.sendMessage(message: messageModel)
                try await chatRepository.saveChat(chat: chatModel, userId: currentUserId)
                messageSentEvent = ()
            } catch {
                errorEvent = error
            }

            isSendingMessageEvent = false
        }
    }

    func sendImageMessage(image: UIImage?) {
        guard let currentUserId, let chat else { return }

        isSendingMessageEvent = true

        Task {
            do {
                guard let image = image else {
                    throw AppError(message: Strings.errorUnknown())
                }

                guard let imageData = image.jpegData(compressionQuality: 0.6) else {
                    throw AppError(message: Strings.errorUnknown())
                }

                let date = Date.now

                let url = try await chatRepository.uploadMessageImage(
                    model: .init(
                        chatId: chatId,
                        imageName: UUID().uuidString,
                        data: imageData
                    )
                )

                let messageModel = ChatMessageModel(
                    id: UUID().uuidString,
                    senderId: currentUserId,
                    chatId: chatId,
                    type: .image,
                    content: url.absoluteString,
                    date: date
                )

                let chatModel = ChatModel(
                    id: chatId,
                    lastMessage: Strings.chatChatsListImageMessagePlaceholderText(),
                    lastUpdateDate: date,
                    opponent: chat.opponent
                )

                try await chatRepository.sendMessage(message: messageModel)
                try await chatRepository.saveChat(chat: chatModel, userId: currentUserId)

            } catch {
                errorEvent = error
            }

            isSendingMessageEvent = false
        }
    }

    func imageActionProvider(for type: ImagePickerProvider.`Type`) -> ImagePickerProvider {
        .init(type: type) { [weak self] image in
            self?.sendImageMessage(image: image)
        }
    }

    // MARK: - Private

    private func groupMessagesToItemsWithSections(
        messages: [ChatMessageModel],
        currentUserId: String
    ) -> [(HeaderItem, [MessageItem])] {
        let calendar = Calendar.current

        let groupedMessagesDict = messages.reduce([Date: [ChatMessageModel]]()) { acc, element in
            var acc = acc

            guard let date = calendar.date(
                from: Calendar.current.dateComponents([.year, .month, .day], from: element.date)
            ) else {
                return acc
            }

            acc[date, default: []].append(element)

            return acc
        }

        let result = groupedMessagesDict
            .map { ($0.key, $0.value) }
            .sorted { $0.0 > $1.0 }
            .map {
                (
                    mapDateToHeaderItem($0.1.first?.date ?? $0.0),
                    $0.1.compactMap { mapMessageToItem($0, currentUserId: currentUserId) }
                )
            }

        return result
    }

    private func mapMessageToItem(
        _ message: ChatMessageModel,
        currentUserId: String
    ) -> MessageItem? {
        let time = DateHelper.Formatters.time24LocalFormatter.string(from: message.date)
        let isBelongToCurrentUser = message.senderId == currentUserId

        switch message.type {
        case .text:
            return .text(
                .init(
                    id: message.id,
                    text: message.content,
                    time: time,
                    isBelongToCurrentUser: isBelongToCurrentUser
                )
            )
        case .image:
            return .image(
                .init(
                    id: message.id,
                    url: message.content,
                    time: time,
                    isBelongToCurrentUser: isBelongToCurrentUser
                )
            )
        case .unknown:
            return nil
        }
    }

    private func mapDateToHeaderItem(_ date: Date) -> HeaderItem {
        .init(date: DateHelper.chatMessagesDateString(from: date))
    }
}

extension ChatViewModel {
    typealias UserViewModel = UserView.ViewModel
    typealias HeaderItem = ChatDateHeaderView.ViewModel

    enum MessageItem: Hashable {
        case text(ChatMessageTextCell.ViewModel)
        case image(ChatMessageImageCell.ViewModel)
    }
}
