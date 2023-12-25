//
//  DateHelper.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation

enum DateHelper {
    enum Formatters {
        static let fullDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter
        }()

        static let dayAndMonthTimeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM, HH:mm"
            return formatter
        }()

        static let isoDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }()

        static let timeSlotFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }()
    }
}
