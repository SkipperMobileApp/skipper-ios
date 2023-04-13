//
//  UtilRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 10.01.2023.
//

import Foundation

protocol UtilRepository {
    func categories() async throws -> [CategoryModel]
    func category(categoryId: String) async throws -> CategoryModel
}

class UtilRepositoryImpl: UtilRepository {
    private let categories: [CategoryModel] = [
        .init(
            id: "1",
            name: "Разработка",
            image: R.image.icCategoryDevelopment()!,
            subcategories: [
                .init(name: "Backend"),
                .init(name: "Frontend"),
                .init(name: "Мобильная разработка"),
                .init(name: "Desktop")
            ]
        ),
        .init(
            id: "2",
            name: "Аналитика",
            image: R.image.icCategoryAnalytics()!,
            subcategories: [
                .init(name: "Бизнес-аналитика"),
                .init(name: "Системная аналитика")
            ]
        ),
        .init(
            id: "3",
            name: "Инфраструктура",
            image: R.image.icCategoryInfrastructure()!,
            subcategories: [
                .init(name: "DevOps"),
                .init(name: "Сетевое обеспечение"),
                .init(name: "Техподдержка")
            ]
        ),
        .init(
            id: "4",
            name: "Тестирование",
            image: R.image.icCategoryQa()!,
            subcategories: [
                .init(name: "Ручное тестирование"),
                .init(name: "Автотестирование")
            ]
        ),
        .init(
            id: "5",
            name: "Дизайн",
            image: R.image.icCategoryDesign()!,
            subcategories: [
                .init(name: "Мобильный дизайн"),
                .init(name: "Принципы UI/UX"),
                .init(name: "Web-дизайн")
            ]
        ),
        .init(
            id: "6",
            name: "Проектирование",
            image: R.image.icCategoryProjectDesign()!,
            subcategories: [
                .init(name: "Проектирование систем"),
                .init(name: "Highload"),
                .init(name: "Бизнес-проектирование")
            ]
        ),
        .init(
            id: "7",
            name: "Программная архитектура",
            image: R.image.icCategoryArchitecture()!,
            subcategories: [
                .init(name: "Мобильная архитектура"),
                .init(name: "Архитектура Web-приложений"),
                .init(name: "Архитектура Backend")
            ]
        ),
        .init(
            id: "8",
            name: "Менеджмент",
            image: R.image.icCategoryManagement()!,
            subcategories: [
                .init(name: "Продуктовый менеджмент"),
                .init(name: "Проектный менеджмент")
            ]
        ),
        .init(
            id: "9",
            name: "Системное программирование",
            image: R.image.icCategorySystemProgramming()!,
            subcategories: [
                .init(name: "Linux"),
                .init(name: "Автоматизация систем")
            ]
        ),
        .init(
            id: "10",
            name: "Мониторинг надежности",
            image: R.image.icCategoryMonitoring()!,
            subcategories: [
                .init(name: "SRE"),
                .init(name: "Инфраструктурный мониторинг")
            ]
        ),
        .init(
            id: "11",
            name: "Информационная безопасность",
            image: R.image.icCategorySecurity()!,
            subcategories: [
                .init(name: "OWASP"),
                .init(name: "Сетевая безопасность"),
                .init(name: "Инфраструктурная безопасность")
            ]
        ),
        .init(
            id: "12",
            name: "Базы данных",
            image: R.image.icCategoryDatabase()!,
            subcategories: [
                .init(name: "SQL"),
                .init(name: "NoSQL"),
                .init(name: "Проектирование БД")
            ]
        ),
        .init(
            id: "13",
            name: "Анализ данных",
            image: R.image.icCategoryDataAnalysis()!,
            subcategories: [
                .init(name: "Математический анализ"),
                .init(name: "Нейронные сети")
            ]
        ),
        .init(
            id: "14",
            name: "Машинное обучение",
            image: R.image.icCategoryMachineLearning()!,
            subcategories: [
                .init(name: "Распознавание образов"),
                .init(name: "Глубокое обучение"),
                .init(name: "Обучение с подкреплением"),
                .init(name: "Обработка естественного языка")
            ]
        )
    ]
}

// MARK: - Categories

extension UtilRepositoryImpl {
    func categories() async throws -> [CategoryModel] {
        try await Task.sleep(for: .seconds(0.5))

        return categories
    }

    func category(categoryId: String) async throws -> CategoryModel {
        try await Task.sleep(for: .seconds(0.5))

        guard let category = categories.first(where: { $0.id == categoryId }) else {
            throw AppError(message: Strings.errorCategoryNotFound())
        }

        return category
    }
}
