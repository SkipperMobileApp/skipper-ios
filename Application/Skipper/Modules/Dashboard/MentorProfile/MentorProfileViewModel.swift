//
//  MentorProfileViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation
import UIKit

class MentorProfileViewModel {
    var title: String {
        "Van Darkholm"
    }

    let statusItems: [StatusItem] = [
        .init(title: "50", subtitle: "ЗАНЯТИЙ"),
        .init(title: "5.0", subtitle: "ОЦЕНКА"),
        .init(title: "10000 дней", subtitle: "НА SKIPPER")
    ]

    let classItems: [ClassItem] = [
        .init(id: "1", title: "Курс по React", description: randomDebugString(wordsCount: 10)),
        .init(id: "2", title: "Курс по React", description: randomDebugString(wordsCount: 10)),
        .init(id: "3", title: "Курс по React", description: randomDebugString(wordsCount: 10))
    ]

    let profileInfo: ProfileInfo = .init(name: "Van Darkholm",
                                         major: "Backend Developer",
                                         description: randomDebugString(wordsCount: 20),
                                         imageURL: "https://clips-media-assets2.twitch.tv/AT-cm%7CDvVLC2hBoIkrmBh1VtqN6A-preview-480x272.jpg")

    let skills: [String] = [
        "Quality Assurance",
        "Data Science",
        "Analytics",
        "Management",
        "SRE",
        "Frontend",
        "Backend"
    ]

    let resumeItems: [ResumeType] = [
        .education(items: [
            .init(
                name: "Сибирский Федеральный Университет",
                startYear: 2016,
                endYear: 2020,
                degree: "Бакалавр"
            ),
            .init(
                name: "Сибирский Федеральный Университет",
                startYear: 2020,
                endYear: 2022,
                degree: "Магистр"
            )
        ]),
        .work(items: [
            .init(
                name: #"ООО "Очень Интересно""#,
                startYear: 2018,
                endYear: 2018,
                post: "Стажер Android Разработчик"
            ),
            .init(
                name: #"ООО "Очень Интересно""#,
                startYear: 2019,
                endYear: 2023,
                post: "iOS Разработчик"
            )
        ]),
        .achievements(items: [
            .init(
                name: "ВКОШП ACM Team Tournament",
                year: 2015,
                info: "9 место"
            ),
            .init(
                name: "Yandex Cup",
                year: 2020,
                info: "9 место"
            ),
            .init(
                name: "Yandex Cup",
                year: 2021,
                info: "12 место"
            )
        ])
    ]

    private let mentorId: String

    init(mentorId: String) {
        self.mentorId = mentorId
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
        let imageURL: String?
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
        let endYear: Int
        let post: String
    }

    struct ResumeAchievmentItem {
        let name: String
        let year: Int
        let info: String
    }
}
