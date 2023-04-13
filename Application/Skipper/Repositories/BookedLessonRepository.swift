//
//  BookedLessonRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2023.
//

import Foundation

protocol BookedLessonRepository {
    func bookLessons(lessons: [BookedLesson]) async throws
    func lessonsForUser(userId: String) async throws -> [BookedLesson]
    func lesson(lessonId: String) async throws -> BookedLesson
}

class BookedLessonRepositoryImpl: BookedLessonRepository {
    private var bookedLessons: [BookedLesson] = []

    func bookLessons(lessons: [BookedLesson]) async throws {
        try await Task.sleep(for: .seconds(0.5))

        bookedLessons.append(contentsOf: lessons)
    }

    func lessonsForUser(userId: String) async throws -> [BookedLesson] {
        try await Task.sleep(for: .seconds(0.5))

        return bookedLessons.filter { $0.userId == userId }
    }

    func lesson(lessonId: String) async throws -> BookedLesson {
        guard let lesson = bookedLessons.first(where: { $0.lessonId == lessonId }) else {
            throw AppError(message: "Занятие не найдено")
        }

        return lesson
    }
}
