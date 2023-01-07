//
//  BookingAmountViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation

protocol BookingAmountViewModel {
    typealias BookingAmount = BookingViewModel.BookingAmount

    var amountItems: [BookingAmount] { get }
    var selectedAmountIndex: Int? { get }
    func setSelectedAmount(at index: Int)

    typealias BookingDuration = BookingViewModel.BookingDuration

    var durationItems: [BookingDuration] { get }
    var selectedDurationIndex: Int? { get }
    func setSelectedDuration(at index: Int)
}
