//
//  DashboardViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Foundation
import UIKit

class DashboardViewModel {
    var sections: [Section] = [
        .categories([
            .init(title: "Разработка", image: nil),
            .init(title: "Аналитика", image: nil),
            .init(title: "Дизайн", image: nil),
            .init(title: "Тестирование", image: nil),
            .init(title: "Инфраструктура", image: nil),
            .init(title: "Менеджмент", image: nil),
            .init(title: "Продуктовая аналитика", image: nil),
            .init(title: "Системный анализ", image: nil),
            .init(title: "Бизнес анализ", image: nil)
        ]),
        .popularMentors([
            .init(
                name: "Thomas Shelby",
                major: "Мегахарош",
                likesCount: 10,
                imageURL: "https://i.tribune.com.pk/media/images/1947471-thomas-1554890232/1947471-thomas-1554890232.png"
            ),
            .init(
                name: "Thomas Angelo",
                major: "Ведущий бизнес-аналитик",
                likesCount: 100,
                imageURL: "https://www.casinos.at/fileadmin/_processed_/b/8/csm_poker-croupier-karten-fliegen-mischen_5dbbb47659.jpg"
            ),
            .init(
                name: "Van Darkholm",
                major: "Эксперт по бэкенду",
                likesCount: 1000,
                imageURL: "https://clips-media-assets2.twitch.tv/AT-cm%7CDvVLC2hBoIkrmBh1VtqN6A-preview-480x272.jpg"
            ),
            .init(
                name: "Homelander",
                major: "Senior HR",
                likesCount: 10000,
                imageURL: "https://www.tvinsider.com/wp-content/uploads/2019/08/the-boys-homelander-1014x570.jpg"
            )
        ])
    ]

    @Published private(set) var categoriesPage: Int = 0

    // MARK: - Data methods

    func setCategoriesCurrentPage(_ page: Int) {
        categoriesPage = page
    }
}

extension DashboardViewModel {
    enum Section {
        case categories([CategoryItem]), popularMentors([MentorItem])

        var title: String {
            switch self {
            case .categories: return Strings.dashboardCategoriesTitle()
            case .popularMentors: return Strings.dashboardPopularMentorsTitle()
            }
        }
    }

    struct CategoryItem {
        let title: String
        let image: UIImage?
    }

    struct MentorItem {
        let name: String
        let major: String
        let likesCount: Int
        let imageURL: String?
    }
}
