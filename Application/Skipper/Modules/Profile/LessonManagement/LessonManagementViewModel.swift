//
//  LessonManagementViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.04.2023.
//

import Foundation

class LessonManagementViewModel {
    // MARK: - Properties

    @Event private(set) var isLoading: Bool?
    @Event private(set) var errorEvent: Error?
    @Event private(set) var updateDataEvent: Void?

    @Injected() private var authRepository: AuthRepository
    @Injected() private var lessonRepostory: LessonRepository

    private(set) var filteredLessons: [LessonItem] = []

    private var lessons: [LessonItem] = [] {
        didSet {
            applyFilters()
        }
    }

    private var searchText: String = "" {
        didSet {
            applyFilters()
        }
    }

    // MARK: - API Calls

    func loadData() {
        isLoading = true
        Task {
            do {
                guard let user = try await authRepository.currentUser() else {
                    throw AppError(message: "Ментор не найден :(")
                }

                let lessons = try await lessonRepostory.lessonsForMentor(mentorId: user.id)

                self.lessons = lessons
                    .sorted { $0.creationDate > $1.creationDate }
                    .map {
                        .init(
                            lessonId: $0.id,
                            title: $0.title,
                            description: $0.brief
                        )
                    }
            } catch {
                errorEvent = error
            }
            isLoading = false
        }
    }

    // MARK: - Data methods

    func setFilterText(_ text: String) {
        searchText = text
    }

    private func applyFilters() {
        defer { updateDataEvent = () }

        guard !searchText.isEmpty else {
            filteredLessons = lessons
            return
        }

        filteredLessons = lessons.filter { $0.title.contains(searchText) }
    }
}

// MARK: - ViewModel

extension LessonManagementViewModel {
    typealias LessonItem = LessonManagementCell.ViewModel
}
