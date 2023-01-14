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

    private let lessonId: String

    init(lessonId: String) {
        self.lessonId = lessonId

        subscribeOnActions()
    }

    private func subscribeOnActions() {
        amountViewModel.$selectedAmountIndex
            .dropFirst()
            .sink { [weak self] _ in
                self?.timeViewModel.clearSelectedItems()
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
                    amountViewModel.setCosts(durations: lesson.durations, costs: lesson.costTable)
                    timeViewModel.setLessonAvailableIntervals(lesson.slots)
                    contactViewModel.setContacts(types: mentor.contacts)

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
        Task {
            try await Task.sleep(for: .seconds(1))

            await MainActor.run {
                bookClassEvent = ()
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
