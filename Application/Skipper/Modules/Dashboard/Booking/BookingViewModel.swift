//
//  BookingViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Combine
import Foundation

class BookingViewModel {
    @Event private(set) var bookClassEvent: Void?
    @Event private(set) var errorEvent: Error?
    @Published private(set) var isLoading: Bool = false

    let typeViewModel = BookingTypeViewModel()
    let amountViewModel = BookingAmountViewModel()
    let timeViewModel = BookingTimeViewModel()
    let contactViewModel = BookingContactViewModel()

    private var subscriptions = Set<AnyCancellable>()

    @Injected() private var lessonRepository: LessonRepository
    @Injected() private var userRepository: UserRepository
    @Injected() private var bookedLessonRepository: BookedLessonRepository
    @Injected() private var authRepository: AuthRepository

    private let lessonId: String
    private var lesson: LessonModel?
    private var mentor: UserModel?

    init(lessonId: String) {
        self.lessonId = lessonId

        subscribeOnActions()
    }

    private func subscribeOnActions() {
        amountViewModel.$selectedAmountIndex
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] index in
                guard let self = self else { return }

                let amount = index.flatMap { self.amountViewModel.amountItems[$0].rawValue } ?? 0
                self.timeViewModel.setAmountOfLessonsToSelect(amount)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Validation

    func validateValues() -> [String] {
        [validateType(), validateAmount(), validateTime(), validateContacts()].flatMap { $0 }
    }

    private func validateType() -> [String] {
        if typeViewModel.selectedItemIndex == nil {
            return ["Тип занятия не выбран"]
        }
        return []
    }

    private func validateAmount() -> [String] {
        var result: [String] = []
        if amountViewModel.selectedAmountIndex == nil {
            result.append("Количество занятий не выбрано")
        }
        if amountViewModel.selectedDurationIndex == nil {
            result.append("Длительность занятий не выбрана")
        }
        return result
    }

    private func validateTime() -> [String] {
        let amountIndex = amountViewModel.selectedAmountIndex ?? 0

        if timeViewModel.selectedTimeItems.count < amountViewModel.amountItems[amountIndex].rawValue {
            return ["Выбрано недостаточное количество дат для занятий"]
        }

        return []
    }

    private func validateContacts() -> [String] {
        if contactViewModel.selectedContactIndex == nil {
            return ["Способ связи не выбран"]
        }

        return []
    }

    // MARK: - Data methods

    func loadData() {
        isLoading = true
        Task {
            do {
                let lesson = try await lessonRepository.lesson(lessonId: lessonId)
                let mentor = try await userRepository.mentor(mentorId: lesson.mentorId)

                await MainActor.run {
                    typeViewModel.setTypes(types: lesson.types)
                    amountViewModel.setData(durations: lesson.durations, costs: lesson.costTable)
                    timeViewModel.setLessonAvailableIntervals(lesson.slots)
                    contactViewModel.setContacts(types: mentor.contacts)

                    self.lesson = lesson
                    self.mentor = mentor

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

    func bookClass() {
        guard
            let lesson = lesson,
            let mentor = mentor,
            let durationIndex = amountViewModel.selectedDurationIndex,
            durationIndex >= 0, durationIndex < lesson.durations.count,
            let cost = lesson.costTable[lesson.durations[durationIndex]],
            let typeIndex = typeViewModel.selectedItemIndex,
            typeIndex >= 0, typeIndex < lesson.types.count,
            timeViewModel.selectedTimeItems.count > 0,
            let contactIndex = contactViewModel.selectedContactIndex,
            contactIndex >= 0, contactIndex < mentor.contacts.count
        else {
            errorEvent = AppError(message: "Ошибка бронирования :(\nПроверьте выбранные данные!")
            return
        }

        isLoading = true
        Task {
            do {
                guard let user = try await authRepository.currentUser(forceUpdate: false) else {
                    throw AppError(message: "Пользователь не найден")
                }

                let bookedLessons = timeViewModel.selectedTimeItems.map {
                    BookedLesson(
                        id: "",
                        userId: user.id,
                        mentorId: mentor.id,
                        lessonId: lesson.id,
                        name: lesson.title,
                        description: lesson.brief,
                        type: lesson.types[typeIndex],
                        cost: cost,
                        date: $0.date,
                        time: $0.timeInterval,
                        duration: lesson.durations[durationIndex],
                        contact: mentor.contacts[contactIndex].type
                    )
                }

                try await bookedLessonRepository.bookLessons(lessons: bookedLessons)

                await MainActor.run {
                    isLoading = false
                    bookClassEvent = ()
                }

            } catch {
                await MainActor.run {
                    isLoading = false
                    errorEvent = error
                }
            }
        }
    }
}

// MARK: - Models

extension BookingViewModel {
    enum Step: CaseIterable {
        case type, amount, time, contact

        var previousStep: Step? {
            switch self {
            case .type: return nil
            case .amount: return .type
            case .time: return .amount
            case .contact: return .time
            }
        }

        var nextStep: Step? {
            switch self {
            case .type: return .amount
            case .amount: return .time
            case .time: return .contact
            case .contact: return nil
            }
        }
    }
}
