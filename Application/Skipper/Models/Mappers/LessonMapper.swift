//
//  LessonMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.09.2023.
//

import Foundation

enum LessonMapper {
    static func lessonDomainToAPI(_ model: LessonModel) -> LessonFirebaseModel {
        .init(
            id: model.id,
            mentorId: model.mentorId,
            title: model.title,
            brief: model.brief,
            durations: model.durations.map(lessonDurationToAPIStringKey),
            slots: model.slots,
            types: model.types.map(lessonTypeToAPIStringKey)
        )
    }

    static func lessonAPIToDomain(_ model: LessonFirebaseModel) -> LessonModel {
        .init(
            id: model.id,
            mentorId: model.mentorId,
            title: model.title,
            brief: model.brief,
            description: "",
            durations: Set(model.durations.compactMap(lessonDurationAPIStringKeyToDomain)),
            slots: model.slots,
            types: Set(model.types.compactMap(lessonTypeAPIStringKeyToDomain))
        )
    }

    static func lessonDurationToAPIStringKey(_ duration: LessonDuration) -> String {
        switch duration {
        case .trial: return "trial"
        case .short: return "short"
        case .mid: return "mid"
        case .long: return "long"
        }
    }

    static func lessonDurationAPIStringKeyToDomain(_ key: String) -> LessonDuration? {
        switch key {
        case "trial": return .trial
        case "short": return .short
        case "mid": return .mid
        case "long": return .long
        default: return nil
        }
    }

    static func lessonTypeToAPIStringKey(_ type: LessonType) -> String {
        switch type {
        case .theoretical: return "theoretical"
        case .practical: return "practical"
        case .solution: return "solution"
        }
    }

    static func lessonTypeAPIStringKeyToDomain(_ key: String) -> LessonType? {
        switch key {
        case "theoretical": return .theoretical
        case "practical": return .practical
        case "solution": return .solution
        default: return nil
        }
    }
}
