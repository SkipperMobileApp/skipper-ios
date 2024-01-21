//
//  ReviewsListViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2024.
//

import Foundation

class ReviewsListViewModel {
    @Event private(set) var loadDataEvent: Void?
    @Event private(set) var errorEvent: Error?

    @Published private(set) var isLoading: Bool = false

    private(set) var reviewItems: [ReviewItem] = []

    @Injected() private var reviewRepository: ReviewRepository

    private let userId: String

    init(userId: String) {
        self.userId = userId
    }

    func loadData() {
        isLoading = true
        Task {
            do {
                self.reviewItems = try await reviewRepository.getReviews(targetUserId: userId)
                    .sorted { $0.date > $1.date }
                    .map(mapReviewToItem)

                loadDataEvent = ()
            } catch {
                errorEvent = error
            }
            isLoading = false
        }
    }

    private func mapReviewToItem(_ model: ReviewModel) -> ReviewItem {
        .init(
            avatarUrl: model.author?.imageUrl,
            name: model.author
                .flatMap { [$0.firstName, $0.lastName].joined(separator: " ") } ?? "Аноним",
            date: DateHelper.chatMessagesDateString(from: model.date),
            text: model.text ?? "",
            rating: model.rating
        )
    }
}

// MARK: - ViewModel

extension ReviewsListViewModel {
    typealias ReviewItem = ReviewsListCell.DisplayData
}
