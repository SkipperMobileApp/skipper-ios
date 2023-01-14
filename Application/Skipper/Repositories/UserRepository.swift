//
//  UserRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation

protocol UserRepository {
    func mentors() async throws -> [UserModel]
    func mentorsOfCategory(categoryId: String) async throws -> [UserModel]
    func mentor(mentorId: String) async throws -> UserModel
}

class UserRepositoryImpl: UserRepository {
    private lazy var users: [UserModel] = [
        .init(
            id: "1",
            email: "van.darkholme@test.com",
            firstName: "Van",
            lastName: "Darkholme",
            patronymic: "",
            bio: "Я всё это хаваю, у меня нет выбора\nЕсли не хочу, чтоб мои будущие дети в школе увидали видео",
            post: "Backend Developer",
            imageURL: "https://clips-media-assets2.twitch.tv/AT-cm%7CDvVLC2hBoIkrmBh1VtqN6A-preview-480x272.jpg",
            isMentor: true,
            contacts: [
                .init(type: .discord, accountName: "VanDarkholme"),
                .init(type: .telegram, accountName: "VanDark")
            ],
            stats: .init(
                lessonsCount: 77,
                rating: 4.3,
                registrationDate: "127 дней",
                reviewsCount: 40
            ),
            tags: ["Backend", "SRE", "Бизнес-аналитика"],
            lessons: [],
            resumeInfo: generateCv()
        ),
        .init(
            id: "2",
            email: "thomas.shelby@test.com",
            firstName: "Thomas",
            lastName: "Shelby",
            patronymic: "",
            bio: "Я всё это хаваю, у меня нет выбора\nЕсли не хочу, чтоб мои будущие дети в школе увидали видео",
            post: "Аналитик со стажем",
            imageURL: "https://i.tribune.com.pk/media/images/1947471-thomas-1554890232/1947471-thomas-1554890232.png",
            isMentor: true,
            contacts: [
                .init(type: .vk, accountName: "thomas_shelby"),
                .init(type: .skype, accountName: "thomas1337")
            ],
            stats: .init(
                lessonsCount: 282,
                rating: 4.6,
                registrationDate: "123 дня",
                reviewsCount: 97
            ),
            tags: ["Бизнес-аналитика", "Системная аналитика", "Проектный менеджмент"],
            lessons: [],
            resumeInfo: generateCv()
        ),
        .init(
            id: "3",
            email: "thomas.shelby@test.com",
            firstName: "Thomas",
            lastName: "Angelo",
            patronymic: "",
            bio: "Я всё это хаваю, у меня нет выбора\nЕсли не хочу, чтоб мои будущие дети в школе увидали видео",
            post: "Мобильный архитектор-муравей",
            imageURL: "https://www.casinos.at/fileadmin/_processed_/b/8/csm_poker-croupier-karten-fliegen-mischen_5dbbb47659.jpg",
            isMentor: true,
            contacts: [
                .init(type: .telegram, accountName: "tommyAngel"),
                .init(type: .skype, accountName: "tommyangelo")
            ],
            stats: .init(
                lessonsCount: 23,
                rating: 3.0,
                registrationDate: "47 дней",
                reviewsCount: 84
            ),
            tags: ["Мобильная архитектура", "Проектирование БД", "Мобильный дизайн"],
            lessons: [],
            resumeInfo: generateCv()
        ),
        .init(
            id: "4",
            email: "homelander@test.com",
            firstName: "Homelander",
            lastName: "",
            patronymic: "",
            bio: "Я всё это хаваю, у меня нет выбора\nЕсли не хочу, чтоб мои будущие дети в школе увидали видео",
            post: "Data learning engineer",
            imageURL: "https://www.tvinsider.com/wp-content/uploads/2019/08/the-boys-homelander-1014x570.jpg",
            isMentor: true,
            contacts: [
                .init(type: .telegram, accountName: "IAmHomelander"),
                .init(type: .discord, accountName: "Homelander")
            ],
            stats: .init(
                lessonsCount: 50,
                rating: 5.0,
                registrationDate: "1549 дней",
                reviewsCount: 31
            ),
            tags: ["Распознавание образов", "Глубокое обучение", "Обучение с подкреплением"],
            lessons: [],
            resumeInfo: generateCv()
        )
    ]

    private func generateCv() -> UserModel.UserResumeInfo {
        .init(
            educationUnits: [
                .init(name: "Сибирский Федеральный Университет", startYear: 2016, endYear: 2020, degree: "Бакалавр"),
                .init(name: "Сибирский Федеральный Университет", startYear: 2020, endYear: 2022, degree: "Магистр")
            ],
            workUnits: [
                .init(name: #"ООО "Очень Интересно""#, startYear: 2019, endYear: 2020, post: "Мобильный разработчик"),
                .init(name: #"ООО "Тинькофф Центр Разработки""#, startYear: 2020, endYear: nil, post: "Android-разработчик")
            ],
            achievementUnits: [
                .init(name: "ВКОШП ACM Team Tournament", year: 2015, info: "9 место"),
                .init(name: "Русский Медвежонок", year: 2008, info: "1 место")
            ]
        )
    }

    private let lessonRepository: LessonRepository
    private let utilRepository: UtilRepository

    init(lessonRepository: LessonRepository, utilRepository: UtilRepository) {
        self.lessonRepository = lessonRepository
        self.utilRepository = utilRepository
    }

    func mentors() async throws -> [UserModel] {
        try await Task.sleep(for: .seconds(1))

        return users.filter { $0.isMentor }
    }

    func mentorsOfCategory(categoryId: String) async throws -> [UserModel] {
        try await Task.sleep(for: .seconds(1))

        let mentors = users.filter { $0.isMentor }

        if mentors.isEmpty { return [] }

        let category = try await utilRepository.category(categoryId: categoryId)

        let subcategoriesSet = Set(category.subcategories.map { $0.name })

        return mentors.filter {
            !Set($0.tags).intersection(subcategoriesSet).isEmpty
        }
    }

    func mentor(mentorId: String) async throws -> UserModel {
        try await Task.sleep(for: .seconds(1))

        guard let mentor = users.filter({ $0.isMentor }).first(where: { $0.id == mentorId }) else {
            throw AppError(message: "Ментор не найден")
        }

        let lessons = try await lessonRepository.lessonsForMentor(mentorId: mentorId)

        var mentorWithLessons = mentor
        mentorWithLessons.lessons = lessons
        return mentorWithLessons
    }
}
