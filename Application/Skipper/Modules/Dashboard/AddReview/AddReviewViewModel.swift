//
//  AddReviewViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 15.01.2024.
//

import Combine
import Foundation

class AddReviewViewModel {
    @Injected() private var reviewRepository: ReviewRepository
    @Injected() private var authRepository: AuthRepository

    @Event private(set) var errorEvent: Error?
    @Event private(set) var addReviewEvent: Void?
    @Published private(set) var isLoading: Bool = false

    private let targetUserId: String
    private let addReviewSubject: PassthroughSubject<Void, Never>

    init(targetUserId: String, addReviewSubject: PassthroughSubject<Void, Never>) {
        self.targetUserId = targetUserId
        self.addReviewSubject = addReviewSubject
    }

    // MARK: - API Calls

    func addReview(content: String, rating: Int, isAnonymous: Bool) {
        isLoading = true
        Task {
            do {
                guard let user = try await authRepository.currentUser(forceUpdate: false) else {
                    throw AppError(message: "Пользователь не найден")
                }

                let requestModel = ReviewRequestModel(
                    targetUserId: targetUserId,
                    authorId: user.id,
                    date: Date.now,
                    text: content,
                    isAnonymous: isAnonymous,
                    rating: Double(rating)
                )

                try await reviewRepository.sendReview(model: requestModel)

                addReviewSubject.send()
                addReviewEvent = ()
            } catch {
                errorEvent = error
            }

            isLoading = false
        }
    }

    // MARK: - Public

    func validate(content: String, rating: Int) -> [String] {
        var results: [String] = []

        if content.trimmed().isEmpty {
            results.append("Текст отзыва должен быть заполнен")
        }

        if rating == 0 {
            results.append("Оценка не выбрана")
        }

        return results
    }
}
