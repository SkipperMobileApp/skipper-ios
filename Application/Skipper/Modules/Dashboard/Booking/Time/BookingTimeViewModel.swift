//
//  BookingTimeViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation
import UIKit

class BookingTimeViewModel {
    // MARK: - Properties

    let bookableDateInterval: DateInterval = {
        let startDate = Calendar.current.startOfDay(for: .now)
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) ?? .now

        return .init(start: startDate, end: endDate)
    }()

    private(set) var selectedTimeItems: [BookingTimeItem] = []

    private(set) var availableBookingIntervals: [BookingTimeInterval] = []

    private var lessonAvailableIntervals: [Int: [String]] = [:]

    // MARK: - Data methods

    func selectInterval(at index: Int, for date: Date) {
        let interval = availableBookingIntervals[index].time

        selectedTimeItems.append(.init(date: date, timeInterval: interval))
    }

    func loadIntervalsFor(date: Date) {
        guard let weekDay = Calendar.current.dateComponents([.weekday], from: date).weekday else {
            availableBookingIntervals = []
            return
        }

        let allIntervals = lessonAvailableIntervals[weekDay - 1]?.map(BookingTimeInterval.init) ?? []

        availableBookingIntervals = allIntervals.filter { interval in
            selectedTimeItems.filter { $0.date == date }.contains { $0.timeInterval == interval.time }
        }
    }

    func statusFor(date: Date) -> BookStatus {
        if selectedTimeItems.contains(where: { $0.date == date }) {
            return .booked
        }

        loadIntervalsFor(date: date)

        return availableBookingIntervals.isEmpty ? .notAvailable : .available
    }

    func deleteSelectedItem(at index: Int) {
        selectedTimeItems.remove(at: index)
    }

    func clearSelectedItems() {
        selectedTimeItems = []
    }

    func setLessonAvailableIntervals(_ intervals: [Int: [String]]) {
        lessonAvailableIntervals = intervals
    }
}

// MARK: - ViewModel

extension BookingTimeViewModel {
    struct BookingTimeInterval {
        let time: String
    }

    struct BookingTimeItem {
        let date: Date
        let timeInterval: String
    }

    enum BookStatus {
        case booked
        case available
        case notAvailable

        var indicatorColor: UIColor? {
            switch self {
            case .booked: return R.color.brandPrimary()
            case .available: return R.color.brandEventAvailable()
            case .notAvailable: return nil
            }
        }
    }
}
