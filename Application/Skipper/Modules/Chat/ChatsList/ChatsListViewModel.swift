//
//  ChatsListViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.12.2023.
//

import Combine
import Foundation

class ChatsListViewModel {
    @Event private(set) var errorEvent: Error?
    @Event private(set) var isLoading: Bool?

    @Injected() private var chatRepository: ChatRepository
    @Injected() private var authRepository: AuthRepository

    @Published private(set) var chats: [ChatItem] = []

    private var chatsSubscription: AnyCancellable?

    func subscribeOnChats() {
        isLoading = true
        Task {
            do {
                guard let userId = try await authRepository.currentUser()?.id else { return }

                chatsSubscription?.cancel()
                chatsSubscription = chatRepository.subscribeOnChats(userId: userId)
                    .receive(on: DispatchQueue.main)
                    .map { [weak self] chats -> [ChatItem] in
                        guard let self else { return [] }

                        return chats
                            .sorted { $0.lastUpdateDate > $1.lastUpdateDate }
                            .map(self.mapChatToItem)
                    }
                    .sink(receiveCompletion: { [weak self] completion in
                        if case let .failure(error) = completion {
                            self?.errorEvent = error
                        }
                    }, receiveValue: { [weak self] chats in
                        self?.chats = chats
                    })
            } catch {
                errorEvent = error
            }

            self.isLoading = false
        }
    }

    private func mapChatToItem(_ chat: ChatModel) -> ChatItem {
        .init(
            id: chat.id,
            opponentId: chat.opponent.id,
            avatarUrl: chat.opponent.imageUrl,
            name: [chat.opponent.firstName, chat.opponent.lastName].joined(separator: " "),
            message: chat.lastMessage,
            date: DateHelper.chatElapsedTimeString(from: chat.lastUpdateDate)
        )
    }
}

extension ChatsListViewModel {
    typealias ChatItem = ChatListCell.ViewModel
}
