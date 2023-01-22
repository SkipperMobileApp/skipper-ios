//
//  SearchMentorViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2023.
//

import Foundation

class SearchMentorViewModel {
    @Event private(set) var itemsUpdatedEvent: Void?
    @Event private(set) var errorEvent: Error?
    @Published private(set) var isLoading: Bool = false

    @Injected() private var userRepository: UserRepository

    var items: [Item] = []
    private var sourceItems: [Item] = []

    private let selectedCategoryId: String?

    init(categoryId: String?) {
        selectedCategoryId = categoryId
    }

    func applySearchText(_ text: String) {
        if text.isEmpty {
            items = sourceItems
            itemsUpdatedEvent = ()
            return
        }

        items = sourceItems.filter { $0.name.lowercased().contains(text.lowercased()) }
        itemsUpdatedEvent = ()
    }

    func loadData() {
        isLoading = true
        Task {
            do {
                let mentors: [UserModel]
                if let categoryId = selectedCategoryId {
                    mentors = try await userRepository.mentorsOfCategory(categoryId: categoryId)
                } else {
                    mentors = try await userRepository.mentors()
                }

                await MainActor.run {
                    sourceItems = mentors.map {
                        .init(
                            id: $0.id,
                            name: [$0.firstName, $0.lastName].joined(separator: " "),
                            major: $0.post,
                            imageUrl: $0.imageUrl,
                            rating: $0.stats.rating,
                            description: $0.bio,
                            subcategories: $0.tags
                        )
                    }
                    applySearchText("")
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorEvent = error
                    isLoading = false
                }
            }
        }
    }
}

extension SearchMentorViewModel {
    struct Item {
        let id: String
        let name: String
        let major: String
        let imageUrl: String?
        let rating: Double
        let description: String
        let subcategories: [String]
    }
}
