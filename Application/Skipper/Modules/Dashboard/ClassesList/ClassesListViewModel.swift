//
//  ClassesListViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation

class ClassesListViewModel {
    @Event private(set) var loadDataEvent: Void?
    @Event private(set) var errorEvent: Error?
    @Published private(set) var isLoading: Bool = false

    @Injected() private(set) var lessonRepository: LessonRepository

    private(set) var items: [Item] = []

    private let mentorId: String

    init(mentorId: String) {
        self.mentorId = mentorId
    }

    func loadData() {
        isLoading = true
        Task {
            do {
                let lessons = try await lessonRepository.lessonsForMentor(mentorId: mentorId)

                await MainActor.run {
                    items = lessons.map {
                        .init(id: $0.id, title: $0.title, description: $0.brief)
                    }
                    loadDataEvent = ()
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

extension ClassesListViewModel {
    struct Item {
        let id: String
        let title: String
        let description: String
    }
}
