//
//  BookedLessonMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 24.09.2023.
//

import Foundation

enum BookedLessonMapper {
    static func bookedLessonDomainToAPI(_ model: BookedLessonModel) -> BookedLessonFirebaseModel {
        .init(
            id: model.id,
            userId: model.userId,
            mentorId: model.mentorId,
            lessonId: model.lessonId,
            name: model.name,
            description: model.description,
            type: lessonTypeToAPIStringKey(model.type),
            dateTime: DateHelper.Formatters.isoDateFormatter.string(from: model.dateTime),
            duration: lessonDurationToAPIStringKey(model.duration),
            contact: userContactTypeToAPIStringKey(model.contact)
        )
    }

    private static func lessonDurationToAPIStringKey(_ duration: LessonDuration) -> String {
        switch duration {
        case .trial: return "trial"
        case .short: return "short"
        case .medium: return "medium"
        case .long: return "long"
        }
    }

    private static func lessonDurationAPIStringKeyToDomain(_ key: String) -> LessonDuration? {
        switch key {
        case "trial": return .trial
        case "short": return .short
        case "medium": return .medium
        case "long": return .long
        default: return nil
        }
    }

    private static func lessonTypeToAPIStringKey(_ type: LessonType) -> String {
        switch type {
        case .theoretical: return "theoretical"
        case .practical: return "practical"
        case .solution: return "solution"
        }
    }

    private static func lessonTypeAPIStringKeyToDomain(_ key: String) -> LessonType? {
        switch key {
        case "theoretical": return .theoretical
        case "practical": return .practical
        case "solution": return .solution
        default: return nil
        }
    }

    private static func userContactTypeToAPIStringKey(_ type: UserContactType) -> String {
        switch type {
        case .discord: return "discord"
        case .skype: return "skype"
        case .telegram: return "telegram"
        case .vk: return "vk"
        }
    }

    private static func userContactTypeAPIStringKeyToDomain(_ key: String) -> UserContactType? {
        switch key {
        case "discord": return .discord
        case "skype": return .skype
        case "telegram": return .telegram
        case "vk": return .vk
        default: return nil
        }
    }
}
