//
//  MyLessonsViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 16.01.2023.
//

import Foundation

class MyLessonsViewModel {
    // MARK: - Properties

    @Event private(set) var isLoading: Bool?
    @Event private(set) var errorEvent: Error?
    @Event private(set) var loadDataEvent: Void?

    @Injected() private var authRepository: AuthRepository
    @Injected() private var bookedLessonRepository: BookedLessonRepository
    @Injected() private var userRepository: UserRepository

    private(set) var lessonItems: [BookedLessonItem] = []

    // MARK: - API Calls

    func loadData() {
        isLoading = true
        Task {
            do {
                guard let user = try await authRepository.currentUser(forceUpdate: false) else {
                    throw AppError(message: Strings.errorUserNotAuthorized())
                }

                let lessons = try await bookedLessonRepository.lessonsForUser(userId: user.id)

                let mentors = try await lessons.asyncCompactMap { [weak self] in
                    try await self?.userRepository.mentor(mentorId: $0.mentorId)
                }

                await MainActor.run {
                    lessonItems = zip(lessons, mentors).map { lesson, mentor in
                        .init(
                            id: lesson.id,
                            lessonId: lesson.lessonId,
                            name: lesson.name,
                            type: titleFromLessonType(lesson.type),
                            mentorName: [
                                mentor.firstName,
                                mentor.lastName
                            ].filter { !$0.isEmpty }.joined(separator: " "),
                            time: timeStringFor(
                                dateTime: lesson.dateTime,
                                duration: lesson.duration
                            ),
                            contact: contactStringFor(
                                lessonContactType: lesson.contact,
                                mentor: mentor,
                                date: lesson.dateTime
                            )
                        )
                    }

                    isLoading = false
                    loadDataEvent = ()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorEvent = error
                }
            }
        }
    }

    // MARK: - Data Methods

    private func titleFromLessonType(_ type: LessonType) -> String {
        switch type {
        case .theoretical: return "Теоретическая консультация"
        case .practical: return "Практическое решение текущих проблем"
        case .solution: return #"Решение "под ключ""#
        }
    }

    private func contactTypeNameFrom(type: UserContactType) -> String {
        switch type {
        case .discord: return "Discord"
        case .skype: return "Skype"
        case .telegram: return "Telegram"
        case .vk: return "VK"
        }
    }

    private func durationFromLessonDuration(_ duration: LessonDuration) -> String {
        if duration == .trial {
            return "\(duration.rawValue) мин. (пробное занятие)"
        }
        return "\(duration.rawValue) мин."
    }

    private func timeStringFor(dateTime: Date, duration: LessonDuration) -> String {
        let dateTimeString = DateHelper.Formatters.dayAndMonthTimeFormatter.string(from: dateTime)
        let durationString = durationFromLessonDuration(duration)

        return [dateTimeString, durationString].filter { !$0.isEmpty }
            .joined(separator: ", ")
    }

    private func contactStringFor(
        lessonContactType: UserContactType,
        mentor: UserModel,
        date: Date
    ) -> String {
        if abs(date.timeIntervalSince(.now)) > 60 * 60 * 24 {
            return "\(contactTypeNameFrom(type: lessonContactType)): Станет видимым за сутки до занятия"
        }

        let typeModel = mentor.contacts.first { $0.type == lessonContactType }
        let contact = typeModel?.accountName ?? "Unknown"
        let name = contactTypeNameFrom(type: typeModel?.type ?? lessonContactType)

        return "\(name): \(contact)"
    }
}

// MARK: - ViewModel

extension MyLessonsViewModel {
    typealias BookedLessonItem = MyLessonsCell.Item
}
