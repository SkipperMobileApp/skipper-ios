//
//  BookingTimeViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation

class BookingTimeViewModel {
    // MARK: - Properties

    let availableDateInterval: DateInterval = {
        let startDate = Calendar.current.startOfDay(for: .now)
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) ?? .now

        return .init(start: startDate, end: endDate)
    }()

    private(set) var selectedTimeItems: [BookingTimeItem] = []

    private(set) var availableIntervals: [BookingTimeInterval] = []

    // MARK: - Data methods

    func selectInterval(at index: Int, for date: Date) {
        let interval = availableIntervals[index].time
        let dateString = DateHelper.Formatters.fullDateFormatter.string(from: date)

        selectedTimeItems.append(.init(date: dateString, timeInterval: interval))
    }

    func loadIntervalsFor(date: Date) {
        availableIntervals = [
            .init(time: "00:00 - 03:00"),
            .init(time: "03:00 - 06:00"),
            .init(time: "06:00 - 09:00"),
            .init(time: "09:00 - 12:00"),
            .init(time: "12:00 - 15:00"),
            .init(time: "15:00 - 18:00"),
            .init(time: "18:00 - 21:00"),
            .init(time: "21:00 - 00:00")
        ]
    }

    func deleteSelectedItem(at index: Int) {
        selectedTimeItems.remove(at: index)
    }

    func clearSelectedItems() {
        selectedTimeItems = []
    }
}

// MARK: - ViewModel

extension BookingTimeViewModel {
    struct BookingTimeInterval {
        let time: String
    }

    struct BookingTimeItem {
        let date: String
        let timeInterval: String
    }
}
