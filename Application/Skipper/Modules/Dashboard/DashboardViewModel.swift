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
                        .categories(
                            categories
                                .sorted { $0.key.rawValue < $1.key.rawValue }
                                .map {
                                    .init(
                                        id: $0.id,
                                        title: $0.name,
                                        image: imageForCategoryKey($0.key)
                                    )
                                }
                        ),
                        .popularMentors(mentors.map {
                            .init(
                                id: $0.id,
                                name: [$0.firstName, $0.lastName].joined(separator: " "),
                                major: $0.post,
                                likesCount: $0.stats.reviewsCount,
                                imageUrl: $0.imageUrl
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

    // MARK: - Mappers

    private func imageForCategoryKey(_ key: CategoryKey) -> UIImage {
        switch key {
        case .development: return R.image.icCategoryDevelopment()!
        case .analytics: return R.image.icCategoryAnalytics()!
        case .infrastructure: return R.image.icCategoryInfrastructure()!
        case .qa: return R.image.icCategoryQa()!
        case .uiDesign: return R.image.icCategoryDesign()!
        case .design: return R.image.icCategoryProjectDesign()!
        case .architecture: return R.image.icCategoryArchitecture()!
        case .management: return R.image.icCategoryManagement()!
        case .systemProgramming: return R.image.icCategorySystemProgramming()!
        case .sre: return R.image.icCategoryMonitoring()!
        case .security: return R.image.icCategorySecurity()!
        case .database: return R.image.icCategoryDatabase()!
        case .dataAnalysis: return R.image.icCategoryDataAnalysis()!
        case .machineLearning: return R.image.icCategoryMachineLearning()!
        case .unknown: return UIImage()
        }
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
        let image: UIImage
    }

    struct MentorItem {
        let id: String
        let name: String
        let major: String
        let likesCount: Int
        let imageUrl: String?
    }
}
