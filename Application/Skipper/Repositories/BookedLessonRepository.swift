//
//  BookedLessonRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2023.
//

import Foundation

protocol BookedLessonRepository {
    func bookLessons(lessons: [BookedLessonModel]) async throws
    func lessonsForUser(userId: String) async throws -> [BookedLessonModel]
    func lesson(lessonId: String) async throws -> BookedLessonModel
    func cancelLesson(lessonId: String) async throws
}

class BookedLessonRepositoryImpl: BookedLessonRepository {
    private var bookedLessons: [BookedLessonModel] = [
        .init(
            id: "1",
            userId: "TE6C0gmMbMYtKzGN2XFGC8qHmfx2",
            mentorId: "1",
            lessonId: "1",
            name: "Консультация React",
            description: "Консультация для овладения базовыми знаниями по React",
            type: .solution,
            date: .now.addingTimeInterval(3600 * 24 * 2),
            time: "18:00 - 21:00",
            duration: .trial,
            contact: .discord
        )
    ]

    func bookLessons(lessons: [BookedLessonModel]) async throws {
        try await Task.sleep(for: .seconds(0.5))

        bookedLessons.append(contentsOf: lessons)
    }

    func lessonsForUser(userId: String) async throws -> [BookedLessonModel] {
        try await Task.sleep(for: .seconds(0.5))

        return bookedLessons.filter { $0.userId == userId }
    }

    func lesson(lessonId: String) async throws -> BookedLessonModel {
        try await Task.sleep(for: .seconds(0.5))

        guard let lesson = bookedLessons.first(where: { $0.lessonId == lessonId }) else {
            throw AppError(message: Strings.errorLessonNotFound())
        }

        return lesson
    }

    func cancelLesson(lessonId: String) async throws {
        try await Task.sleep(for: .seconds(0.5))

        bookedLessons.removeAll { $0.lessonId == lessonId }
    }
}
