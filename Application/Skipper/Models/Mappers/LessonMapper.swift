//
//  LessonMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.09.2023.
//

import Foundation

enum LessonMapper {
    static func lessonDomainToAPI(_ model: LessonModel) -> LessonFirebaseModel {
        LessonFirebaseModel(
            id: model.id,
            mentorId: model.mentorId,
            title: model.title,
            brief: model.brief,
            durations: model.durations.map(lessonDurationToAPIStringKey),
            slots: model.slots.mapValues { $0.map(lessonTimeSlotDomainToAPI) },
            types: model.types.map(lessonTypeToAPIStringKey),
            createdAt: Int(model.creationDate.timeIntervalSince1970),
            updatedAt: Int(model.updationDate.timeIntervalSince1970)
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
            slots: model.slots.mapValues { $0.map(lessonTimeSlotAPIToDomain) },
            types: Set(model.types.compactMap(lessonTypeAPIStringKeyToDomain)),
            creationDate: Date(timeIntervalSince1970: Double(model.createdAt)),
            updationDate: Date(timeIntervalSince1970: Double(model.updatedAt))
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

    private static func lessonTimeSlotDomainToAPI(
        _ model: LessonModel.LessonTimeSlot
    ) -> LessonFirebaseModel.LessonTimeSlot {
        .init(
            startTime: DateHelper.Formatters.timeSlotFormatter.string(from: model.startTime),
            endTime: DateHelper.Formatters.timeSlotFormatter.string(from: model.endTime)
        )
    }

    private static func lessonTimeSlotAPIToDomain(
        _ model: LessonFirebaseModel.LessonTimeSlot
    ) -> LessonModel.LessonTimeSlot {
        .init(
            startTime: DateHelper.Formatters.timeSlotFormatter.date(
                from: model.startTime
            ) ?? Date(timeIntervalSince1970: 0),
            endTime: DateHelper.Formatters.timeSlotFormatter.date(
                from: model.endTime
            ) ?? Date(timeIntervalSince1970: 0)
        )
    }
}
