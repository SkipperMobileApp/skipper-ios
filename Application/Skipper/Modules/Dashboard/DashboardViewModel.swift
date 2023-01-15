//
//  DashboardViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Foundation
import UIKit

class DashboardViewModel {
    @Injected() private var userRepository: UserRepository
    @Injected() private var utilRepository: UtilRepository

    @Event private(set) var loadDataEvent: Void?
    @Event private(set) var errorEvent: Error?
    @Published private(set) var isLoading: Bool = false

    @Published private(set) var categoriesPage: Int = 0
    var sections: [Section] = []

    // MARK: - Data methods

    func loadData() {
        isLoading = true
        Task {
            do {
                let mentors = try await userRepository.mentors()
                let categories = try await utilRepository.categories()

                await MainActor.run {
                    sections = [
                        .categories(categories.map {
                            .init(id: $0.id, title: $0.name, imageURL: $0.imageURL)
                        }),
                        .popularMentors(mentors.map {
                            .init(
                                id: $0.id,
                                name: [$0.firstName, $0.lastName, $0.patronymic].joined(separator: " "),
                                major: $0.post,
                                likesCount: $0.stats.reviewsCount,
                                imageURL: $0.imageURL
                            )
                        })
                    ]
                    loadDataEvent = ()
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorEvent = error
                    isLoading = false
                }
            }
        }
    }

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
        let id: String
        let title: String
        let imageURL: String?
    }

    struct MentorItem {
        let id: String
        let name: String
        let major: String
        let likesCount: Int
        let imageURL: String?
    }
}
