//
//  BookingAmountViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation

class BookingAmountViewModel {
    var totalCost: Int {
        guard let amountIndex = selectedAmountIndex,
              let durationIndex = selectedDurationIndex else { return 0 }

        return (costs[durationItems[durationIndex]] ?? 0) * amountItems[amountIndex].rawValue
    }

    private let trialAmountItems: [BookingAmount] = [.one]
    private let defaultAmountItems: [BookingAmount] = [.one, .three, .five]

    private(set) lazy var amountItems: [BookingAmount] = defaultAmountItems
    private(set) var durationItems: [BookingDuration] = []

    @Published private(set) var selectedAmountIndex: Int?
    private(set) var selectedDurationIndex: Int?

    private var costs: [BookingDuration: Int] = [:]

    // MARK: - Initializations

    func setData(durations: [LessonDuration], costs: [LessonDuration: Int]) {
        durationItems = durations.map(BookingDuration.init)
            .sorted(by: { $0.rawValue < $1.rawValue })

        self.costs = durations.reduce([BookingDuration: Int]()) { acc, item in
            var acc = acc
            acc[BookingDuration(from: item)] = costs[item]
            return acc
        }
    }

    // MARK: - Data items

    func setSelectedAmount(at index: Int) {
        if index != selectedAmountIndex {
            selectedAmountIndex = index
        }
    }

    func setSelectedDuration(at index: Int) {
        selectedDurationIndex = index

        if durationItems[index] == .trial {
            selectedAmountIndex = nil
            amountItems = trialAmountItems
        } else {
            amountItems = defaultAmountItems
        }
    }
}

extension BookingAmountViewModel {
    enum BookingAmount: Int {
        case one = 1, three = 3, five = 5

        var title: String {
            switch self {
            case .one: return "1 занятие"
            case .three: return "3 занятия"
            case .five: return "5 занятий"
            }
        }
    }

    enum BookingDuration: Int {
        case trial, short, mid, long

        var title: String {
            switch self {
            case .trial: return "15 минут (пробное)"
            case .short: return "30 минут"
            case .mid: return "60 минут"
            case .long: return "90 минут"
            }
        }

        init(from duration: LessonDuration) {
            switch duration {
            case .trial: self = .trial
            case .short: self = .short
            case .mid: self = .mid
            case .long: self = .long
            }
        }
    }
}
