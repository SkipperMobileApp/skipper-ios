//
//  LessonDetailsViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 10.04.2023.
//

import Foundation

class LessonDetailsViewModel {
    // MARK: - Properties

    @Event private(set) var isLoading: Bool?
    @Event private(set) var errorEvent: Error?
    @Event private(set) var cancelLessonEvent: Void?

    @Injected() private var bookedLessonRepository: BookedLessonRepository
    @Injected() private var userRepository: UserRepository

    @Published private(set) var lessonInfo: LessonInfo = .placeholder

    private let lessonId: String

    // MARK: - Initialization

    init(lessonId: String) {
        self.lessonId = lessonId
    }

    // MARK: - API Methods

    func loadData() {
        isLoading = true
        Task {
            do {
                let bookedLesson = try await bookedLessonRepository.lesson(lessonId: lessonId)
                let mentor = try await userRepository.mentor(mentorId: bookedLesson.mentorId)

                await MainActor.run {
                    lessonInfo = .init(
                        title: bookedLesson.name,
                        type: LessonInfo.titleFromLessonType(bookedLesson.type),
                        mentorName: [
                            mentor.lastName,
                            mentor.firstName
                        ].filter { !$0.isEmpty }.joined(separator: ""),
                        mentorAvatarUrl: mentor.imageUrl,
                        description: bookedLesson.description,
                        time: LessonInfo.timeStringFor(
                            date: bookedLesson.date,
                            time: bookedLesson.time,
                            duration: bookedLesson.duration
                        ),
                        contact: LessonInfo.contactStringFor(
                            lessonContactType: bookedLesson.contact,
                            mentor: mentor,
                            date: bookedLesson.date
                        )
                    )
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

    func cancelLesson() {
        isLoading = true

        Task {
            do {
                try await bookedLessonRepository.cancelLesson(lessonId: lessonId)
                cancelLessonEvent = ()
            } catch {
                errorEvent = error
            }
            isLoading = false
        }
    }
}

// MARK: - ViewModel

extension LessonDetailsViewModel {
    struct LessonInfo {
        let title: String
        let type: String
        let mentorName: String
        let mentorAvatarUrl: String?

        let description: String
        let time: String
        let contact: String

        static var placeholder: Self {
            .init(
                title: "",
                type: "",
                mentorName: "",
                mentorAvatarUrl: "",
                description: "",
                time: "",
                contact: ""
            )
        }

        static func titleFromLessonType(_ type: LessonType) -> String {
            switch type {
            case .theoretical: return "Теоретическая консультация"
            case .practical: return "Практическое решение текущих проблем"
            case .solution: return #"Решение "под ключ""#
            }
        }

        static func contactTypeNameFrom(type: UserContactType) -> String {
            switch type {
            case .discord: return "Discord"
            case .skype: return "Skype"
            case .telegram: return "Telegram"
            case .vk: return "VK"
            }
        }

        static func durationFromLessonDuration(_ duration: LessonDuration) -> String {
            if duration == .trial {
                return "\(duration.rawValue) мин. (пробное занятие)"
            }
            return "\(duration.rawValue) мин."
        }

        static func timeStringFor(date: Date, time: String, duration: LessonDuration) -> String {
            let dateString = DateHelper.Formatters.dayAndMonthFormatter.string(from: date)
            let timeString = String(time.split(separator: " - ").first ?? "") // Temporary
            let durationString = durationFromLessonDuration(duration)

            return [dateString, timeString, durationString].filter { !$0.isEmpty }
                .joined(separator: ", ")
        }

        static func contactStringFor(
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
}
