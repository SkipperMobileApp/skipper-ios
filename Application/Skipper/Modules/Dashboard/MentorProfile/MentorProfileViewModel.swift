//
//  MentorProfileViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Combine
import Foundation
import UIKit

class MentorProfileViewModel {
    private(set) var title: String = ""
    private(set) var statusItems: [StatusItem] = []
    private(set) var classItems: [ClassItem] = []
    private(set) var profileInfo: ProfileInfo = .init(
        name: "",
        major: "",
        description: "",
        imageUrl: nil
    )
    private(set) var skills: [String] = []
    private(set) var resumeItems: [ResumeType] = []
    private(set) var reviewItems: [ReviewItem] = []

    @Event private(set) var loadDataEvent: Void?
    @Event private(set) var errorEvent: Error?
    @Published private(set) var isLoading: Bool = false
    private var addReviewEventSubscription: AnyCancellable?

    @Injected() private var userRepository: UserRepository
    @Injected() private var reviewRepository: ReviewRepository

    private let mentorId: String

    init(mentorId: String) {
        self.mentorId = mentorId
    }

    func loadData() {
        isLoading = true
        Task {
            do {
                let mentor = try await userRepository.mentor(mentorId: mentorId)

                reviewItems = try await reviewRepository.getReviews(targetUserId: mentorId)
                    .sorted { $0.date > $1.date }
                    .map(mapReviewToItem)

                title = [mentor.firstName, mentor.lastName].joined(separator: " ")

                var rating: Double = 0
                if reviewItems.count > 0 {
                    rating = reviewItems.map(\.rating).reduce(0.0, +) / Double(reviewItems.count)
                }

                statusItems = [
                    .init(
                        title: String(mentor.stats.lessonsCount),
                        subtitle: "ЗАНЯТИЙ"
                    ),
                    .init(
                        title: String(format: "%.1lf", rating),
                        subtitle: "ОЦЕНКА"
                    ),
                    .init(
                        title: mentor.stats.registrationDate.isEmpty ? "0 дней" : mentor.stats
                            .registrationDate,
                        subtitle: "НА SKIPPER"
                    )
                ]

                classItems = mentor.lessons
                    .sorted { $0.updationDate > $1.updationDate }
                    .map {
                        .init(id: $0.id, title: $0.title, description: $0.brief)
                    }

                profileInfo = .init(
                    name: [mentor.firstName, mentor.lastName].joined(separator: " "),
                    major: mentor.post,
                    description: mentor.bio,
                    imageUrl: mentor.imageUrl
                )

                skills = mentor.tags

                resumeItems = [
                    .education(
                        items: mentor.resumeInfo.educationUnits.map {
                            .init(
                                name: $0.name,
                                startYear: $0.startYear,
                                endYear: $0.endYear,
                                degree: $0.degree
                            )
                        }
                    ),
                    .work(
                        items: mentor.resumeInfo.workUnits.map {
                            .init(
                                name: $0.name,
                                startYear: $0.startYear,
                                endYear: $0.endYear,
                                post: $0.post
                            )
                        }
                    ),
                    .achievements(
                        items: mentor.resumeInfo.achievementUnits.map {
                            .init(
                                name: $0.name,
                                year: $0.year,
                                info: $0.info
                            )
                        }
                    )
                ]

                loadDataEvent = ()
            } catch {
                errorEvent = error
            }
            isLoading = false
        }
    }

    func getAddReviewEvent() -> PassthroughSubject<Void, Never> {
        let subject = PassthroughSubject<Void, Never>()

        addReviewEventSubscription = subject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadData()
            }

        return subject
    }

    private func mapReviewToItem(_ model: ReviewModel) -> ReviewItem {
        .init(
            avatarUrl: model.author?.imageUrl,
            name: model.author
                .flatMap { [$0.firstName, $0.lastName].joined(separator: " ") } ?? "Аноним",
            date: DateHelper.chatMessagesDateString(from: model.date),
            text: model.text ?? "",
            rating: model.rating
        )
    }
}

extension MentorProfileViewModel {
    struct StatusItem {
        let title: String
        let subtitle: String
    }

    struct ClassItem {
        let id: String
        let title: String
        let description: String
    }

    struct ProfileInfo {
        let name: String
        let major: String
        let description: String
        let imageUrl: String?
    }

    enum ResumeType {
        case education(items: [ResumeEducationItem])
        case work(items: [ResumeWorkItem])
        case achievements(items: [ResumeAchievmentItem])

        var title: String {
            switch self {
            case .education: return "Образование"
            case .work: return "Опыт работы"
            case .achievements: return "Достижения"
            }
        }

        var icon: UIImage {
            switch self {
            case .education: return R.icon.educationCircle
            case .work: return R.icon.briefCaseCircle
            case .achievements: return R.icon.starCircle
            }
        }
    }

    struct ResumeEducationItem {
        let name: String
        let startYear: Int
        let endYear: Int
        let degree: String
    }

    struct ResumeWorkItem {
        let name: String
        let startYear: Int
        let endYear: Int?
        let post: String
    }

    struct ResumeAchievmentItem {
        let name: String
        let year: Int
        let info: String
    }

    typealias ReviewItem = MentorProfileReviewsView.DisplayData
}
