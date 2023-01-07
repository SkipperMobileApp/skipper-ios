//
//  BookingViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation

class BookingViewModel: BookingTypeViewModel, BookingAmountViewModel {
    private let classId: String

    init(classId: String) {
        self.classId = classId
    }

    // MARK: - BookingTypeViewModel

    private(set) var selectedItemIndex: Int?

    private(set) var typeItems: [BookingTypeItem] = [
        .init(
            id: "1",
            title: "Теоретическая консультация",
            description: "Решение профильных вопросов в устной форме"
        ),
        .init(
            id: "2",
            title: "Практическое решение текущих проблем",
            description: "Разбор практического решения задачи"
        ),
        .init(
            id: "3",
            title: #"Решение "под ключ""#,
            description: "Описание задачи с последующим онлайн-решением"
        )
    ]

    func setSelectedItem(at index: Int) {
        selectedItemIndex = index
    }

    // MARK: - BookingAmountViewModel

    private(set) var selectedAmountIndex: Int?
    private(set) var selectedDurationIndex: Int?

    private(set) var amountItems: [BookingAmount] = [.one, .three, .five]
    private(set) var durationItems: [BookingDuration] = [.trial, .short, .mid, .long]

    func setSelectedAmount(at index: Int) {
        selectedAmountIndex = index
    }

    func setSelectedDuration(at index: Int) {
        selectedDurationIndex = index
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

    struct BookingTypeItem {
        let id: String
        let title: String
        let description: String
    }

    enum BookingAmount {
        case one, three, five

        var title: String {
            switch self {
            case .one: return "1 занятие"
            case .three: return "3 занятия"
            case .five: return "5 занятий"
            }
        }
    }

    enum BookingDuration {
        case trial, short, mid, long

        var title: String {
            switch self {
            case .trial: return "15 минут (пробное занятие)"
            case .short: return "30 минут"
            case .mid: return "60 минут"
            case .long: return "90 минут"
            }
        }
    }
}
