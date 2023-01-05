//
//  SearchMentorViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2023.
//

import Foundation

class SearchMentorViewModel {
    @Event private(set) var itemsUpdatedEvent: Void?

    var items: [Item] = []

    private var sourceItems: [Item] = [
        .init(
            name: "Van Darkholm",
            major: "Backend Developer",
            imageURL: "https://clips-media-assets2.twitch.tv/AT-cm%7CDvVLC2hBoIkrmBh1VtqN6A-preview-480x272.jpg",
            rating: 5.0,
            description: randomDebugString(wordsCount: 20),
            subcategories: ["Backend", "SRE", "Python", "Frontend", "Swift", "Kotlin"]
        ),
        .init(
            name: "Thomas Shelby",
            major: "Мегахарош",
            imageURL: "https://i.tribune.com.pk/media/images/1947471-thomas-1554890232/1947471-thomas-1554890232.png",
            rating: 5.0,
            description: randomDebugString(wordsCount: 10),
            subcategories: ["Backend", "SRE", "Python"]
        ),
        .init(
            name: "Thomas Angelo",
            major: "Backend Developer",
            imageURL: "https://www.casinos.at/fileadmin/_processed_/b/8/csm_poker-croupier-karten-fliegen-mischen_5dbbb47659.jpg",
            rating: 5.0,
            description: randomDebugString(wordsCount: 15),
            subcategories: ["Backend", "SRE", "Python"]
        ),
        .init(
            name: "Homelander",
            major: "Backend Developer",
            imageURL: "https://www.tvinsider.com/wp-content/uploads/2019/08/the-boys-homelander-1014x570.jpg",
            rating: 5.0,
            description: randomDebugString(wordsCount: 25),
            subcategories: ["Backend", "SRE", "Python"]
        )
    ]

    private let selectedCategory: String?

    init(category: String?) {
        selectedCategory = category
        applySearchText("")
    }

    func applySearchText(_ text: String) {
        if text.isEmpty {
            items = sourceItems
            itemsUpdatedEvent = ()
            return
        }

        items = sourceItems.filter { $0.name.lowercased().contains(text.lowercased()) }
        itemsUpdatedEvent = ()
    }
}

extension SearchMentorViewModel {
    struct Item {
        let name: String
        let major: String
        let imageURL: String?
        let rating: Double
        let description: String
        let subcategories: [String]
    }
}
