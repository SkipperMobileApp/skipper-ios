//
//  LessonRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation

protocol LessonRepository {
    func lessonsForMentor(mentorId: String) async throws -> [LessonModel]
}

class LessonRepositoryImpl: LessonRepository {
    lazy var lessons = [
        LessonModel(
            id: "1",
            mentorId: "1",
            title: "Консультация React",
            brief: "Консультация для овладения базовыми знаниями по React",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "2",
            mentorId: "1",
            title: "Консультация Android",
            brief: "Разработка приложения на Android под присмотром специалиста со стажем",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "3",
            mentorId: "1",
            title: "Консультация Flask",
            brief: "Получение базовых навыков по бэкэнду на примере Flask Framework",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "4",
            mentorId: "2",
            title: "Консультация React",
            brief: "Консультация для овладения базовыми знаниями по React",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "5",
            mentorId: "2",
            title: "Консультация Android",
            brief: "Разработка приложения на Android под присмотром специалиста со стажем",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "6",
            mentorId: "2",
            title: "Консультация Flask",
            brief: "Получение базовых навыков по бэкэнду на примере Flask Framework",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "7",
            mentorId: "3",
            title: "Консультация React",
            brief: "Консультация для овладения базовыми знаниями по React",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "8",
            mentorId: "3",
            title: "Консультация Android",
            brief: "Разработка приложения на Android под присмотром специалиста со стажем",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "9",
            mentorId: "3",
            title: "Консультация Flask",
            brief: "Получение базовых навыков по бэкэнду на примере Flask Framework",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "10",
            mentorId: "4",
            title: "Консультация React",
            brief: "Консультация для овладения базовыми знаниями по React",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "11",
            mentorId: "4",
            title: "Консультация Android",
            brief: "Разработка приложения на Android под присмотром специалиста со стажем",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        ),
        LessonModel(
            id: "12",
            mentorId: "4",
            title: "Консультация Flask",
            brief: "Получение базовых навыков по бэкэнду на примере Flask Framework",
            description: "",
            appointmentDate: Date.now,
            costTable: mockCostTable(),
            slots: mockFreeSlots()
        )
    ]

    // Int - day of week from monday - [0-6]
    private func mockFreeSlots() -> [Int: [String]] {
        [
            0: ["18:00 - 21:00"],
            2: ["12:00 - 15:00", "15:00 - 18:00", "18:00 - 21:00"],
            3: ["15:00 - 18:00", "18:00 - 21:00"],
            6: ["12:00 - 15:00", "15:00 - 18:00", "18:00 - 21:00"]
        ]
    }

    private func mockCostTable() -> [LessonDuration: Int] {
        return [
            LessonDuration.trial: 100,
            LessonDuration.short: 500,
            LessonDuration.mid: 1000,
            LessonDuration.long: 1500
        ]
    }

    func lessonsForMentor(mentorId: String) async throws -> [LessonModel] {
        try await Task.sleep(for: .seconds(1))

        return lessons.filter { $0.mentorId == mentorId }
    }
}
