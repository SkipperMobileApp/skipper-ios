//
//  BookingTypeViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation

class BookingTypeViewModel {
    private(set) var selectedItemIndex: Int?

    private(set) var typeItems: [BookingTypeItem] = [
        .init(
            id: "1",
            title: "Теоретическая консультация",
            description: "Решение профильных вопросов в устной форме"
        ),
        .init(
            id: "2",
            title: "Практическое решение текущих проблем",
            description: "Разбор практического решения задачи"
        ),
        .init(
            id: "3",
            title: #"Решение "под ключ""#,
            description: "Описание задачи с последующим онлайн-решением"
        )
    ]

    func setSelectedItem(at index: Int) {
        selectedItemIndex = index
    }
}

extension BookingTypeViewModel {
    struct BookingTypeItem {
        let id: String
        let title: String
        let description: String
    }
}
