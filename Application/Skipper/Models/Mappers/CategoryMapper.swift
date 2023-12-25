//
//  CategoryMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 24.09.2023.
//

import Foundation

enum CategoryMapper {
    static func categoryFromAPIToDomain(_ model: CategoryFirebaseModel) -> CategoryModel {
        .init(
            id: model.id,
            name: model.name,
            key: categoryKeyDomainFromAPI(model.key),
            subcategories: model.subcategories.map { .init(name: $0) }
        )
    }

    private static func categoryKeyDomainFromAPI(_ key: String) -> CategoryKey {
        switch key {
        case "development": return .development
        case "analytics": return .analytics
        case "infrastructure": return .infrastructure
        case "qa": return .qa
        case "ui_design": return .uiDesign
        case "design": return .design
        case "architecture": return .architecture
        case "management": return .management
        case "system_programming": return .systemProgramming
        case "sre": return .sre
        case "security": return .security
        case "database": return .database
        case "data_analysis": return .dataAnalysis
        case "machine_learning": return .machineLearning
        default: return .unknown
        }
    }
}
