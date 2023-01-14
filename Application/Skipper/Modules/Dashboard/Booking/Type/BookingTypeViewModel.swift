//
//  BookingTypeViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation

class BookingTypeViewModel {
    private(set) var selectedItemIndex: Int?

    @Published private(set) var typeItems: [BookingTypeItem] = []

    func setTypes(types: [LessonType]) {
        typeItems = types.map(BookingTypeItem.init)
    }

    func setSelectedItem(at index: Int) {
        selectedItemIndex = index
    }
}

// MARK: - ViewModel

extension BookingTypeViewModel {
    struct BookingTypeItem {
        let title: String
        let description: String

        init(title: String, description: String) {
            self.title = title
            self.description = description
        }

        init(from type: LessonType) {
            switch type {
            case .theoretical:
                self = .init(
                    title: "Теоретическая консультация",
                    description: "Решение профильных вопросов в устной форме"
                )
            case .practical:
                self = .init(
                    title: "Практическое решение текущих проблем",
                    description: "Разбор практического решения задачи"
                )
            case .solution:
                self = .init(
                    title: #"Решение "под ключ""#,
                    description: "Описание задачи с последующим онлайн-решением"
                )
            }
        }
    }
}
