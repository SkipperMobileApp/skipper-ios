//
//  BookingContactViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation

class BookingContactViewModel {
    let contactTypes: [BookingContactType] = BookingContactType.allCases

    private(set) var contactValues: [BookingContactType: String] = [:]

    func saveContactValues(_ values: [BookingContactType: String]) {
        contactValues = values
    }
}

extension BookingContactViewModel {
    enum BookingContactType: CaseIterable {
        case discord

        var title: String {
            switch self {
            case .discord: return "Discord"
            }
        }

        var placeholder: String {
            switch self {
            case .discord: return "Логин от Discord"
            }
        }

        var imageURL: String? {
            switch self {
            case .discord: return "https://cdn3.iconfinder.com/data/icons/popular-services-brands-vol-2/512/discord-512.png"
            }
        }
    }
}
