//
//  DateHelper.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation

enum DateHelper {
    enum Constants {
        static let daySeconds: TimeInterval = 60 * 60 * 24
        static let weekSeconds: TimeInterval = daySeconds * 7
    }

    enum Formatters {
        static let fullDateLocalFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter
        }()

        static let dayAndMonthTimeLocalFormatter: DateFormatter = {
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

        static let time24GMT0Formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.calendar = .current
            return formatter
        }()

        static let time24LocalFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()

        static let weekdayLocalFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return formatter
        }()

        static let dateLocalFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            return formatter
        }()

        static let dayAndMonthLocalFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM"
            return formatter
        }()
    }

    static func chatElapsedTimeString(from date: Date) -> String {
        let elapsedSeconds = Date.now.timeIntervalSince(date)

        if elapsedSeconds < Constants.daySeconds {
            return Formatters.time24LocalFormatter.string(from: date)
        }

        if elapsedSeconds < Constants.weekSeconds {
            return Formatters.weekdayLocalFormatter.string(from: date)
        }

        return Formatters.dateLocalFormatter.string(from: date)
    }

    static func chatMessagesDateString(from date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return Strings.chatChatMessagesDateToday()
        }

        if Calendar.current.isDateInYesterday(date) {
            return Strings.chatChatMessagesDateYesterday()
        }

        let dateYear = Calendar.current.component(.year, from: date)
        let currentYear = Calendar.current.component(.year, from: date)

        if currentYear != dateYear {
            return Formatters.fullDateLocalFormatter.string(from: date)
        }

        return Formatters.dayAndMonthLocalFormatter.string(from: date)
    }
}
