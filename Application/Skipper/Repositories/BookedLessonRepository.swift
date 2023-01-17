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
}

class BookedLessonRepositoryImpl: BookedLessonRepository {
    private var bookedLessons: [BookedLesson] = [
        .init(
            id: "1",
            userId: "1",
            mentorId: "1",
            lessonId: "1",
            name: "Консультация React",
            description: "Консультация для овладения базовыми знаниями по React",
            type: .solution,
            cost: 100,
            date: .now.addingTimeInterval(3600 * 24 * 2),
            time: "18:00 - 21:00",
            duration: .trial,
            contact: .discord
        )
    ]

    func bookLessons(lessons: [BookedLesson]) async throws {
        try await Task.sleep(for: .seconds(0.5))

        bookedLessons.append(contentsOf: lessons)
    }

    func lessonsForUser(userId: String) async throws -> [BookedLesson] {
        try await Task.sleep(for: .seconds(0.5))

        return bookedLessons // .filter { $0.userId == userId }
    }
}
