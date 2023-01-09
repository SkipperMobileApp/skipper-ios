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
            imageURL: nil,
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
            imageURL: nil,
            subcategories: [
                .init(name: "Бизнес-аналитика"),
                .init(name: "Системная аналитика")
            ]
        ),
        .init(
            id: "3",
            name: "Инфраструктура",
            imageURL: nil,
            subcategories: [
                .init(name: "DevOps"),
                .init(name: "Сетевое обеспечение"),
                .init(name: "Техподдержка")
            ]
        ),
        .init(
            id: "4",
            name: "Тестирование",
            imageURL: nil,
            subcategories: [
                .init(name: "Ручное тестирование"),
                .init(name: "Автотестирование")
            ]
        ),
        .init(
            id: "5",
            name: "Дизайн",
            imageURL: nil,
            subcategories: [
                .init(name: "Мобильный дизайн"),
                .init(name: "Принципы UI/UX"),
                .init(name: "Web-дизайн")
            ]
        ),
        .init(
            id: "6",
            name: "Проектирование",
            imageURL: nil,
            subcategories: [
                .init(name: "Проектирование систем"),
                .init(name: "Highload"),
                .init(name: "Бизнес-проектирование")
            ]
        ),
        .init(
            id: "7",
            name: "Программная архитектура",
            imageURL: nil,
            subcategories: [
                .init(name: "Мобильная архитектура"),
                .init(name: "Архитектура Web-приложений"),
                .init(name: "Архитектура Backend")
            ]
        ),
        .init(
            id: "8",
            name: "Менеджмент",
            imageURL: nil,
            subcategories: [
                .init(name: "Продуктовый менеджмент"),
                .init(name: "Проектный менеджмент")
            ]
        ),
        .init(
            id: "9",
            name: "Системное программирование",
            imageURL: nil,
            subcategories: [
                .init(name: "Linux"),
                .init(name: "Автоматизация систем")
            ]
        ),
        .init(
            id: "10",
            name: "Мониторинг надежности",
            imageURL: nil,
            subcategories: [
                .init(name: "SRE"),
                .init(name: "Инфраструктурный мониторинг")
            ]
        ),
        .init(
            id: "11",
            name: "Информационная безопасность",
            imageURL: nil,
            subcategories: [
                .init(name: "OWASP"),
                .init(name: "Сетевая безопасность"),
                .init(name: "Инфраструктурная безопасность")
            ]
        ),
        .init(
            id: "12",
            name: "Базы данных",
            imageURL: nil,
            subcategories: [
                .init(name: "SQL"),
                .init(name: "NoSQL"),
                .init(name: "Проектирование БД")
            ]
        ),
        .init(
            id: "13",
            name: "Анализ данных",
            imageURL: nil,
            subcategories: [
                .init(name: "Математический анализ"),
                .init(name: "Нейронные сети")
            ]
        ),
        .init(
            id: "14",
            name: "Машинное обучение",
            imageURL: nil,
            subcategories: [
                .init(name: "Распознавание образов"),
                .init(name: "Глубокое обучение"),
                .init(name: "Обучение с подкреплением"),
                .init(name: "Обработка естественного языка")
            ]
        )
    ]

    func categories() async throws -> [CategoryModel] {
        try await Task.sleep(for: .seconds(1))

        return categories
    }

    func category(categoryId: String) async throws -> CategoryModel {
        try await Task.sleep(for: .seconds(1))

        guard let category = categories.first(where: { $0.id == categoryId }) else {
            throw AppError(message: "Категория не найдена")
        }

        return category
    }
}
