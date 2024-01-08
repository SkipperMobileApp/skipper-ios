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
    @Event private(set) var loadChatEvent: ChatModel?
    @Event private(set) var cancelLessonEvent: Void?

    @Injected() private var bookedLessonRepository: BookedLessonRepository
    @Injected() private var userRepository: UserRepository
    @Injected() private var chatRepository: ChatRepository
    @Injected() private var authRepository: AuthRepository

    @Published private(set) var lessonInfo: LessonInfo = .placeholder

    private let lessonId: String
    private(set) var mentor: UserModel?
    private(set) var hasSendMessageOption: Bool = false

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

                self.mentor = mentor

                await MainActor.run {
                    hasSendMessageOption =
                        bookedLesson.dateTime.timeIntervalSinceNow < 60 * 60 * 24

                    lessonInfo = .init(
                        title: bookedLesson.name,
                        type: LessonInfo.titleFromLessonType(bookedLesson.type),
                        mentorName: [
                            mentor.lastName,
                            mentor.firstName
                        ].filter { !$0.isEmpty }.joined(separator: " "),
                        mentorAvatarUrl: mentor.imageUrl,
                        description: bookedLesson.description,
                        time: LessonInfo.timeStringFor(
                            dateTime: bookedLesson.dateTime,
                            duration: bookedLesson.duration
                        ),
                        contact: LessonInfo.contactStringFor(
                            lessonContactType: bookedLesson.contact,
                            mentor: mentor,
                            date: bookedLesson.dateTime
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

    func loadChat() {
        isLoading = true
        Task {
            defer {
                isLoading = false
            }

            do {
                guard let user = try await authRepository.currentUser(forceUpdate: false),
                      let mentor = self.mentor
                else {
                    throw AppError(message: Strings.errorUnknown())
                }

                if let chat = try await chatRepository.getChatWithOpponent(
                    userId: user.id,
                    opponentId: mentor.id
                ) {
                    loadChatEvent = chat
                    return
                }

                let chatModel = ChatModel(
                    id: UUID().uuidString,
                    lastMessage: Strings.chatChatListFirstMessageText(),
                    lastUpdateDate: .now,
                    opponent: mentor
                )

                try await chatRepository.saveChat(chat: chatModel, userId: user.id)

                loadChatEvent = chatModel
            } catch {
                errorEvent = error
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

        static func timeStringFor(dateTime: Date, duration: LessonDuration) -> String {
            let dateTimeString = DateHelper.Formatters.dayAndMonthTimeLocalFormatter
                .string(from: dateTime)
            let durationString = durationFromLessonDuration(duration)

            return [dateTimeString, durationString].filter { !$0.isEmpty }
                .joined(separator: ", ")
        }

        static func contactStringFor(
            lessonContactType: UserContactType,
            mentor: UserModel,
            date: Date
        ) -> String {
            if date.timeIntervalSinceNow > 60 * 60 * 24 {
                return "\(contactTypeNameFrom(type: lessonContactType)): Станет видимым за сутки до занятия"
            }

            let typeModel = mentor.contacts.first { $0.type == lessonContactType }
            let contact = typeModel?.accountName ?? "Unknown"
            let name = contactTypeNameFrom(type: typeModel?.type ?? lessonContactType)

            return "\(name): \(contact)"
        }
    }
}
