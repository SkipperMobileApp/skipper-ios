//
//  BookingContactViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation
import UIKit

class BookingContactViewModel {
    private(set) var contactTypes: [BookingContactType] = []

    private(set) var selectedContactIndex: Int?

    func setContacts(types: [UserContactModel]) {
        contactTypes = types.map { .init(from: $0.type) }
    }

    func setSelectedIndex(_ index: Int) {
        selectedContactIndex = index
    }
}

extension BookingContactViewModel {
    enum BookingContactType: Int, CaseIterable {
        case discord
        case skype
        case telegram
        case vk

        init(from type: UserContactType) {
            switch type {
            case .discord: self = .discord
            case .skype: self = .skype
            case .telegram: self = .telegram
            case .vk: self = .vk
            }
        }

        var title: String {
            switch self {
            case .discord: return "Discord"
            case .skype: return "Skype"
            case .telegram: return "Telegram"
            case .vk: return "VK"
            }
        }

        var image: UIImage? {
            switch self {
            case .discord: return R.image.logoContactDiscord()
            case .skype: return R.image.logoContactSkype()
            case .telegram: return R.image.logoContactTelegram()
            case .vk: return R.image.logoContactVk()
            }
        }
    }
}
