//
//  LessonInfoViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 17.04.2023.
//

import Combine
import Foundation

class LessonInfoViewModel {
    @Event private(set) var isLoading: Bool?
    @Event private(set) var errorEvent: Error?
    @Event private(set) var loadLessonEvent: LessonInfo?
    @Event private(set) var saveLessonEvent: Void?

    @Injected() private var authRepository: AuthRepository
    @Injected() private var lessonRepository: LessonRepository

    @Published private(set) var wasDataChanged: Bool = false

    private var lessonInfo: LessonInfo = .empty
    private let lessonId: String?

    var isNewLesson: Bool {
        lessonId == nil
    }

    // MARK: - Initialization

    init(lessonId: String?) {
        self.lessonId = lessonId
    }

    // MARK: - API Calls

    func loadData() {
        guard let lessonId = lessonId else {
            return
        }

        isLoading = true
        Task {
            do {
                let lesson = try await lessonRepository.lesson(lessonId: lessonId)

                lessonInfo = LessonInfo(
                    name: lesson.title,
                    description: lesson.brief,
                    types: Set(lesson.types.map(LessonType.init)),
                    durations: Set(lesson.durations.map(LessonDuration.init)),
                    timePeriods: lesson.slots
                        .compactMap { (slot: (key: Int, value: [LessonModel.LessonTimeSlot])) -> [TimePeriod]? in

                            guard let weekday = Weekday(rawValue: slot.key) else { return nil }

                            return slot.value.map {
                                return TimePeriod(
                                    weekday: weekday,
                                    startTime: $0.startTime,
                                    endTime: $0.endTime
                                )
                            }
                        }
                        .flatMap { $0 },
                    creationDate: lesson.creationDate
                )

                loadLessonEvent = lessonInfo
            } catch {
                errorEvent = error
            }
            isLoading = false
        }
    }

    func saveLesson() {
        guard wasDataChanged else { return }

        isLoading = true

        Task {
            do {
                guard let mentor = try await authRepository.currentUser(forceUpdate: false) else {
                    throw AppError(message: "Пользователь не найден")
                }

                try await lessonRepository.saveLesson(
                    lesson: makeLessonModel(lessonId: lessonId, mentorId: mentor.id)
                )

                saveLessonEvent = ()
            } catch {
                errorEvent = error
            }

            isLoading = false
        }
    }

    // MARK: - Data Methods

    func validateData() -> String? {
        var results: [String] = []

        if lessonInfo.name.isEmpty {
            results.append("Название не должно быть пустым")
        }

        if lessonInfo.description.isEmpty {
            results.append("Описание не должно быть пустым")
        }

        if lessonInfo.types.isEmpty {
            results.append("Тип занятия не выбран")
        }

        if lessonInfo.durations.isEmpty {
            results.append("Длительность занятия не выбрана")
        }

        if lessonInfo.timePeriods.isEmpty {
            results.append("Временные интервалы занятия не заданы")
        }

        return results.isEmpty ? nil : results.joined(separator: "\n")
    }

    func setLessonName(_ name: String) {
        lessonInfo.name = name

        wasDataChanged = true
    }

    func setLessonDescription(_ description: String) {
        lessonInfo.description = description

        wasDataChanged = true
    }

    func setLessonDuration(_ duration: LessonDuration, isSelected: Bool) {
        if isSelected {
            lessonInfo.durations.insert(duration)
        } else {
            lessonInfo.durations.remove(duration)
        }

        wasDataChanged = true
    }

    func setLessonType(_ type: LessonType, isSelected: Bool) {
        if isSelected {
            lessonInfo.types.insert(type)
        } else {
            lessonInfo.types.remove(type)
        }

        wasDataChanged = true
    }

    func getTimePeriod(at index: Int) -> TimePeriod? {
        guard index >= 0, index < lessonInfo.timePeriods.count else { return nil }

        return lessonInfo.timePeriods[index]
    }

    func bookTimePeriod(_ period: TimePeriod, replacingIndex: Int? = nil) {
        if replacingIndex == nil || replacingIndex == lessonInfo.timePeriods.count {
            lessonInfo.timePeriods.append(period)
        } else {
            lessonInfo.timePeriods[replacingIndex ?? 0] = period
        }

        wasDataChanged = true
    }

    func freeTimePeriod(at index: Int) {
        guard index >= 0, index < lessonInfo.timePeriods.count else { return }

        lessonInfo.timePeriods.remove(at: index)

        wasDataChanged = true
    }

    private func makeLessonModel(lessonId: String?, mentorId: String) -> LessonModel {
        let durations = Set(
            Skipper.LessonDuration.allCases.filter {
                lessonInfo.durations.contains(LessonDuration($0))
            }
        )

        let types = Set(
            Skipper.LessonType.allCases.filter {
                lessonInfo.types.contains(LessonType($0))
            }
        )

        let slots = lessonInfo.timePeriods
            .reduce([Int: [LessonModel.LessonTimeSlot]]()) { acc, item in
                var acc = acc
                acc[item.weekday.rawValue, default: []]
                    .append(.init(startTime: item.startTime, endTime: item.endTime))
                return acc
            }

        return .init(
            id: lessonId ?? UUID().uuidString,
            mentorId: mentorId,
            title: lessonInfo.name,
            brief: lessonInfo.description,
            description: "",
            durations: durations,
            slots: slots,
            types: types,
            creationDate: lessonInfo.creationDate ?? Date.now,
            updationDate: Date.now
        )
    }
}

// MARK: - View Model

extension LessonInfoViewModel {
    struct LessonInfo {
        var name: String
        var description: String
        var types: Set<LessonType>
        var durations: Set<LessonDuration>
        var timePeriods: [TimePeriod]
        let creationDate: Date?

        static var empty: LessonInfo {
            .init(
                name: "",
                description: "",
                types: [],
                durations: [],
                timePeriods: [],
                creationDate: nil
            )
        }
    }

    struct TimePeriod: Hashable {
        let weekday: Weekday
        let startTime: Date
        let endTime: Date

        var fullTime: String {
            [
                DateHelper.Formatters.timeSlotFormatter.string(from: startTime),
                DateHelper.Formatters.timeSlotFormatter.string(from: endTime)
            ].joined(separator: " - ")
        }
    }

    enum LessonType: CaseIterable {
        case theoretical, practical, solution

        init(_ type: Skipper.LessonType) {
            switch type {
            case .theoretical: self = .theoretical
            case .practical: self = .practical
            case .solution: self = .solution
            }
        }

        var title: String {
            switch self {
            case .theoretical: return "Теоретическая консультация"
            case .practical: return "Практическое решение текущих проблем"
            case .solution: return #"Решение "под ключ""#
            }
        }
    }

    enum LessonDuration: CaseIterable {
        case trial, short, medium, long

        init(_ duration: Skipper.LessonDuration) {
            switch duration {
            case .trial: self = .trial
            case .short: self = .short
            case .medium: self = .medium
            case .long: self = .long
            }
        }

        var title: String {
            switch self {
            case .trial: return "15 минут (пробное занятие)"
            case .short: return "30 минут"
            case .medium: return "60 минут"
            case .long: return "90 минут"
            }
        }
    }

    enum Weekday: Int, CaseIterable {
        case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday

        var title: String {
            switch self {
            case .monday: return "Понедельник"
            case .tuesday: return "Вторник"
            case .wednesday: return "Среда"
            case .thursday: return "Четверг"
            case .friday: return "Пятница"
            case .saturday: return "Суббота"
            case .sunday: return "Воскресенье"
            }
        }
    }

    enum Field: String, CaseIterable {
        case name, description, type, duration, time

        var headerTitle: String {
            switch self {
            case .name: return "Название"
            case .description: return "Описание занятия"
            case .type: return "Тип занятия"
            case .duration: return "Длительность"
            case .time: return "Временные интервалы"
            }
        }

        var placeholder: String? {
            switch self {
            case .name: return "Введите название"
            case .description: return "Введите описание"
            default: return nil
            }
        }
    }
}
