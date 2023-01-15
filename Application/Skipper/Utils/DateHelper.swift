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
    }
}
