//
//  ClassesListViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation

class ClassesListViewModel {
    var items: [Item] = [
        .init(id: "1", title: "Консультация по React", description: randomDebugString(wordsCount: 10)),
        .init(id: "2", title: "Консультация по React", description: randomDebugString(wordsCount: 10)),
        .init(id: "3", title: "Консультация по React", description: randomDebugString(wordsCount: 15)),
        .init(id: "4", title: "Консультация по React", description: randomDebugString(wordsCount: 20)),
        .init(id: "5", title: "Консультация по React", description: randomDebugString(wordsCount: 5)),
        .init(id: "6", title: "Консультация по React", description: randomDebugString(wordsCount: 12))
    ]

    private let mentorId: String

    init(mentorId: String) {
        self.mentorId = mentorId
    }
}

extension ClassesListViewModel {
    struct Item {
        let id: String
        let title: String
        let description: String
    }
}
