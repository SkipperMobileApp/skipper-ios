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
    lazy var lessons = [
        LessonModel(
            id: "1",
            mentorId: "1",
            title: "Консультация React",
            brief: "Консультация для овладения базовыми знаниями по React",
            description: "",
            durations: [.trial, .short, .long],
            slots: mockFreeSlots(),
            types: [.theoretical]
        ),
        LessonModel(
            id: "2",
            mentorId: "1",
            title: "Консультация Android",
            brief: "Разработка приложения на Android под присмотром специалиста со стажем",
            description: "",
            durations: [.short, .mid, .long],
            slots: mockFreeSlots(),
            types: [.theoretical, .practical]
        ),
        LessonModel(
            id: "3",
            mentorId: "1",
            title: "Консультация Flask",
            brief: "Получение базовых навыков по бэкэнду на примере Flask Framework",
            description: "",
            durations: [.trial, .short, .mid, .long],
            slots: mockFreeSlots(),
            types: [.theoretical, .practical, .solution]
        ),
        LessonModel(
            id: "4",
            mentorId: "2",
            title: "Консультация React",
            brief: "Консультация для овладения базовыми знаниями по React",
            description: "",
            durations: [.mid],
            slots: mockFreeSlots(),
            types: [.practical, .solution]
        ),
        LessonModel(
            id: "5",
            mentorId: "2",
            title: "Консультация Android",
            brief: "Разработка приложения на Android под присмотром специалиста со стажем",
            description: "",
            durations: [.trial, .mid, .long],
            slots: mockFreeSlots(),
            types: [.theoretical, .solution]
        ),
        LessonModel(
            id: "6",
            mentorId: "2",
            title: "Консультация Flask",
            brief: "Получение базовых навыков по бэкэнду на примере Flask Framework",
            description: "",
            durations: [.trial, .mid],
            slots: mockFreeSlots(),
            types: [.practical]
        ),
        LessonModel(
            id: "7",
            mentorId: "3",
            title: "Консультация React",
            brief: "Консультация для овладения базовыми знаниями по React",
            description: "",
            durations: [.long],
            slots: mockFreeSlots(),
            types: [.solution]
        ),
        LessonModel(
            id: "8",
            mentorId: "3",
            title: "Консультация Android",
            brief: "Разработка приложения на Android под присмотром специалиста со стажем",
            description: "",
            durations: [.trial, .short, .mid],
            slots: mockFreeSlots(),
            types: [.theoretical, .practical, .solution]
        ),
        LessonModel(
            id: "9",
            mentorId: "3",
            title: "Консультация Flask",
            brief: "Получение базовых навыков по бэкэнду на примере Flask Framework",
            description: "",
            durations: [.mid, .long],
            slots: mockFreeSlots(),
            types: [.theoretical, .solution]
        ),
        LessonModel(
            id: "10",
            mentorId: "4",
            title: "Консультация React",
            brief: "Консультация для овладения базовыми знаниями по React",
            description: "",
            durations: [.mid, .long],
            slots: mockFreeSlots(),
            types: [.practical, .solution]
        ),
        LessonModel(
            id: "11",
            mentorId: "4",
            title: "Консультация Android",
            brief: "Разработка приложения на Android под присмотром специалиста со стажем",
            description: "",
            durations: [.trial, .short],
            slots: mockFreeSlots(),
            types: [.theoretical, .practical]
        ),
        LessonModel(
            id: "12",
            mentorId: "4",
            title: "Консультация Flask",
            brief: "Получение базовых навыков по бэкэнду на примере Flask Framework",
            description: "",
            durations: [.trial],
            slots: mockFreeSlots(),
            types: [.theoretical]
        ),
        LessonModel(
            id: "13",
            mentorId: "TE6C0gmMbMYtKzGN2XFGC8qHmfx2",
            title: "Консультация iOS SDK",
            brief: "Получение навыков работы с iOS SDK",
            description: "",
            durations: [.trial],
            slots: mockFreeSlots(),
            types: [.theoretical]
        ),
        LessonModel(
            id: "14",
            mentorId: "TE6C0gmMbMYtKzGN2XFGC8qHmfx2",
            title: "Расширенный курс iOS SDK (Middle)",
            brief: "Расширенный курс по iOS SDK, который позволит получить знания уровня Middle",
            description: "",
            durations: [.trial],
            slots: mockFreeSlots(),
            types: [.theoretical]
        ),
        LessonModel(
            id: "15",
            mentorId: "TE6C0gmMbMYtKzGN2XFGC8qHmfx2",
            title: "Консультация SwiftUI",
            brief: "Получение базовых навыков по работе с фреймворком SwiftUI",
            description: "",
            durations: [.trial],
            slots: mockFreeSlots(),
            types: [.theoretical]
        )
    ]

    // MARK: - Lessons

    // Int - day of week from sunday [0-6]
    private func mockFreeSlots() -> [Int: [String]] {
        [
            1: ["18:00 - 21:00"], // Monday
            3: ["12:00 - 15:00", "15:00 - 18:00", "18:00 - 21:00"], // Wednesday
            4: ["15:00 - 18:00", "18:00 - 21:00"], // Thursday
            0: ["12:00 - 15:00", "15:00 - 18:00", "18:00 - 21:00"] // Sunday
        ]
    }

    private func mockCostTable() -> [LessonDuration: Int] {
        return [
            .trial: 100,
            .short: 500,
            .mid: 1000,
            .long: 1500
        ]
    }
}

extension LessonRepositoryImpl: LessonRepository {
    func lessonsForMentor(mentorId: String) async throws -> [LessonModel] {
        try await Task.sleep(for: .seconds(0.5))

        return lessons.filter { $0.mentorId == mentorId }
    }

    func lesson(lessonId: String) async throws -> LessonModel {
        try await Task.sleep(for: .seconds(0.5))

        guard let lesson = lessons.first(where: { $0.id == lessonId }) else {
            throw AppError(message: Strings.errorLessonNotFound())
        }

        return lesson
    }

    func saveLesson(lesson: LessonModel) async throws {
        try await Task.sleep(for: .seconds(0.5))

        if let index = lessons.firstIndex(where: { $0.id == lesson.id }) {
            lessons[index] = lesson
            return
        }

        var lesson = lesson

        if lesson.id.isEmpty {
            lesson.id = UUID().uuidString
        }
        lessons.append(lesson)
    }
}
