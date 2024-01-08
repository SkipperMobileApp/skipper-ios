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

    func user(userId: String) async throws -> UserModel
    func users(userIds: [String]) async throws -> [UserModel]
    func updateUser(user: UserModel) async throws
    func uploadUserImage(userImage: UserImageUploadModel) async throws -> URL
}

class UserRepositoryImpl {
    private lazy var users: [UserModel] = [
        .init(
            id: "1",
            email: "van.darkholme@test.com",
            firstName: "Van",
            lastName: "Darkholme",
            bio: "Занимаюсь backend-разработкой уже более 5 лет. Работал в ведущих зарубежных компаниях уровня FAANG.",
            post: "Backend Developer",
            imageUrl: "https://clips-media-assets2.twitch.tv/AT-cm%7CDvVLC2hBoIkrmBh1VtqN6A-preview-480x272.jpg",
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
            bio: "Отлично анализирую обстановку, читаю людей и проектную документацию. Победитель Birmingham Whiskey Cup 1921",
            post: "Аналитик со стажем",
            imageUrl: "https://i.tribune.com.pk/media/images/1947471-thomas-1554890232/1947471-thomas-1554890232.png",
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
            email: "thomas.angelo@test.com",
            firstName: "Thomas",
            lastName: "Angelo",
            bio: "Опыт работы в сфере - 9 лет. Разрабатывал архитектуру приложений-гигантов в индустрии продакт-плейсмента.",
            post: "Мобильный архитектор-муравей",
            imageUrl: "https://www.casinos.at/fileadmin/_processed_/b/8/csm_poker-croupier-karten-fliegen-mischen_5dbbb47659.jpg",
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
            bio: "Обучаю необучаемое. Чем вы глупее бездушных машин?",
            post: "Data learning engineer",
            imageUrl: "https://www.tvinsider.com/wp-content/uploads/2019/08/the-boys-homelander-1014x570.jpg",
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
        ),
        .init(
            id: "TE6C0gmMbMYtKzGN2XFGC8qHmfx2",
            email: "den.kovalev999@gmail.com",
            firstName: "Денис",
            lastName: "Ковалёв",
            bio: "Просто здравствуй, просто как дела",
            post: "iOS разработчик",
            imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/skipper-bdc2b.appspot.com/o/avatars%2FTE6C0gmMbMYtKzGN2XFGC8qHmfx2.jpg?alt=media&token=ee2b9d0b-5860-4d39-9ac7-87d32e6a1223",
            isMentor: true,
            contacts: [.init(type: .vk, accountName: "@bard_10x")],
            stats: .init(
                lessonsCount: 0,
                rating: 0,
                registrationDate: "150 дней",
                reviewsCount: 0
            ),
            tags: ["Мобильная разработка", "iOS-разработка"],
            lessons: [],
            resumeInfo: .init(
                educationUnits: [],
                workUnits: [],
                achievementUnits: []
            )
        ),
        .init(
            id: "CGnN0oa2vDfB3Y1zX2rUYFbOcuq1",
            email: "max.kovalev15@gmail.com",
            firstName: "Maxim",
            lastName: "Kovalev",
            bio: "Привет! Я Android-разработчик с многолетним опытом! Даю советы и не только.",
            post: "Android-разработчик",
            imageUrl: "https://firebasestorage.googleapis.com/v0/b/skipper-bdc2b.appspot.com/o/avatars%2F8mjGFeBDMcRWjRX4ySG684jTZoG3.jpg?alt=media&token=af1bf714-385b-4c48-9652-9a53fcd02a65",
            isMentor: true,
            contacts: [.init(type: .vk, accountName: "@cakewalker")],
            stats: .init(
                lessonsCount: 0,
                rating: 0,
                registrationDate: "2 дня",
                reviewsCount: 0
            ),
            tags: ["Мобильная разработка", "Android-разработка"],
            lessons: [],
            resumeInfo: generateCv()
        )
    ]

    private let lessonRepository: LessonRepository
    private let utilRepository: UtilRepository
    private let database: FirestoreDatabase
    private let storage: StorageDatabase

    init(
        lessonRepository: LessonRepository,
        utilRepository: UtilRepository,
        database: FirestoreDatabase,
        storage: StorageDatabase
    ) {
        self.lessonRepository = lessonRepository
        self.utilRepository = utilRepository
        self.database = database
        self.storage = storage
    }

    // MARK: - Private

    private func generateCv() -> UserModel.UserResumeInfo {
        .init(
            educationUnits: [
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
            ],
            workUnits: [
                .init(
                    name: #"ООО "Очень Интересно""#,
                    startYear: 2019,
                    endYear: 2020,
                    post: "Мобильный разработчик"
                ),
                .init(
                    name: #"ООО "Тинькофф Центр Разработки""#,
                    startYear: 2020,
                    endYear: nil,
                    post: "Android-разработчик"
                )
            ],
            achievementUnits: [
                .init(name: "ВКОШП ACM Team Tournament", year: 2015, info: "9 место"),
                .init(name: "Русский Медвежонок", year: 2008, info: "1 место")
            ]
        )
    }
}

extension UserRepositoryImpl: UserRepository {
    func mentors() async throws -> [UserModel] {
        try await Task.sleep(for: .seconds(0.5))

        return users.filter { $0.isMentor }
    }

    func mentorsOfCategory(categoryId: String) async throws -> [UserModel] {
        try await Task.sleep(for: .seconds(0.5))

        let mentors = users.filter { $0.isMentor }

        if mentors.isEmpty { return [] }

        let category = try await utilRepository.category(categoryId: categoryId)

        let subcategoriesSet = Set(category.subcategories.map { $0.name })

        return mentors.filter {
            !Set($0.tags).intersection(subcategoriesSet).isEmpty
        }
    }

    func mentor(mentorId: String) async throws -> UserModel {
        try await Task.sleep(for: .seconds(0.5))

        guard let mentor = users.filter({ $0.isMentor }).first(where: { $0.id == mentorId }) else {
            throw AppError(message: Strings.errorMentorNotFound())
        }

        let lessons = try await lessonRepository.lessonsForMentor(mentorId: mentorId)

        var mentorWithLessons = mentor
        mentorWithLessons.lessons = lessons
        return mentorWithLessons
    }

    func user(userId: String) async throws -> UserModel {
        guard let user = try await database.user(userId: userId) else {
            throw AppError(message: Strings.errorUserNotFound())
        }

        return UserMapper.apiToDomain(user)
    }

    func users(userIds: [String]) async throws -> [UserModel] {
        return try await database.users(userIds: userIds).map(UserMapper.apiToDomain)
    }

    func updateUser(user: UserModel) async throws {
        try await database.updateUsers(users: [UserMapper.domainToAPI(user)])
    }

    func uploadUserImage(userImage: UserImageUploadModel) async throws -> URL {
        try await storage.uploadUserImage(model: UserImageMapper.uploadDomainToAPI(userImage))
    }
}
