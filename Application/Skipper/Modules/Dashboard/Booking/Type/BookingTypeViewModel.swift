//
//  BookingTypeViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation

protocol BookingTypeViewModel {
    typealias BookingTypeItem = BookingViewModel.BookingTypeItem

    var selectedItemIndex: Int? { get }

    var typeItems: [BookingTypeItem] { get }

    func setSelectedItem(at index: Int)
}
