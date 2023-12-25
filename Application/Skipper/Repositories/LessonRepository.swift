//
//  LessonRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation

protocol LessonRepository {
    func lessonsForMentor(mentorId: String) async throws -> [LessonModel]
    func lesson(lessonId: String) async throws -> LessonModel
    func saveLesson(lesson: LessonModel) async throws
}

class LessonRepositoryImpl {
    private let database: FirestoreDatabase

    init(database: FirestoreDatabase) {
        self.database = database
    }
}

extension LessonRepositoryImpl: LessonRepository {
    func lessonsForMentor(mentorId: String) async throws -> [LessonModel] {
        try await Task.sleep(for: .seconds(0.5))

        return try await database
            .lessonsForMentor(mentorId: mentorId)
            .map(LessonMapper.lessonAPIToDomain)
    }

    func lesson(lessonId: String) async throws -> LessonModel {
        try await Task.sleep(for: .seconds(0.5))

        guard let lesson = try await database.lesson(lessonId: lessonId) else {
            throw AppError(message: Strings.errorLessonNotFound())
        }

        return LessonMapper.lessonAPIToDomain(lesson)
    }

    func saveLesson(lesson: LessonModel) async throws {
        try await Task.sleep(for: .seconds(0.5))

        try await database.updateLesson(lesson: LessonMapper.lessonDomainToAPI(lesson))
    }
}
