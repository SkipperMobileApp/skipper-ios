//
//  BookedLessonRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2023.
//

import Foundation

protocol BookedLessonRepository {
    func bookLessons(lessons: [BookedLesson]) async throws
}

class BookedLessonRepositoryImpl: BookedLessonRepository {
    private var bookedLessons: [BookedLesson] = []

    func bookLessons(lessons: [BookedLesson]) async throws {
        bookedLessons.append(contentsOf: lessons)
    }
}
