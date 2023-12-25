//
//  LessonFirebaseModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.09.2023.
//

import FirebaseFirestore
import Foundation

struct LessonFirebaseModel {
    let id: String
    let mentorId: String
    let title: String
    let brief: String
    let durations: [String]
    let slots: [Int: [LessonTimeSlot]]
    let types: [String]
    let createdAt: Int
    let updatedAt: Int

    init(
        id: String,
        mentorId: String,
        title: String,
        brief: String,
        durations: [String],
        slots: [Int: [LessonTimeSlot]],
        types: [String],
        createdAt: Int,
        updatedAt: Int
    ) {
        self.id = id
        self.mentorId = mentorId
        self.title = title
        self.brief = brief
        self.durations = durations
        self.slots = slots
        self.types = types
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension LessonFirebaseModel: FirebaseModel {
    enum CodingKeys: String {
        case id
        case mentorId = "mentor_id"
        case title
        case brief
        case durations
        case slots
        case types
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init?(_ dict: [String: Any], id: String) {
        guard let mentorId = dict[CodingKeys.mentorId.rawValue] as? String,
              let title = dict[CodingKeys.title.rawValue] as? String,
              let brief = dict[CodingKeys.brief.rawValue] as? String,
              let durations = dict[CodingKeys.durations.rawValue] as? [String],
              let slots = dict[CodingKeys.slots.rawValue] as? [String: [[String: Any]]],
              let types = dict[CodingKeys.types.rawValue] as? [String],
              let createdAt = dict[CodingKeys.createdAt.rawValue] as? Int,
              let updatedAt = dict[CodingKeys.updatedAt.rawValue] as? Int
        else { return nil }

        self.id = id
        self.mentorId = mentorId
        self.title = title
        self.brief = brief
        self.durations = durations
        self.slots = slots.reduce([Int: [LessonTimeSlot]]()) { acc, element in
            guard let intKey = Int(element.key) else { return acc }

            var acc = acc
            acc[intKey] = element.value.compactMap(LessonTimeSlot.init)
            return acc
        }
        self.types = types
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.mentorId.rawValue: mentorId,
            CodingKeys.title.rawValue: title,
            CodingKeys.brief.rawValue: brief,
            CodingKeys.durations.rawValue: durations,
            CodingKeys.slots.rawValue: slots.reduce([String: [[String: Any]]]()) { acc, element in
                var acc = acc
                acc[String(element.key)] = element.value.map { $0.toDictionary() }
                return acc
            },
            CodingKeys.types.rawValue: types,
            CodingKeys.createdAt.rawValue: createdAt,
            CodingKeys.updatedAt.rawValue: updatedAt
        ]
    }
}

extension LessonFirebaseModel {
    struct LessonTimeSlot {
        let startTime: String
        let endTime: String

        init(startTime: String, endTime: String) {
            self.startTime = startTime
            self.endTime = endTime
        }

        enum CodingKeys: String {
            case startTime = "start_time"
            case endTime = "end_time"
        }

        init?(from dict: [String: Any]) {
            guard let startTime = dict[CodingKeys.startTime.rawValue] as? String,
                  let endTime = dict[CodingKeys.endTime.rawValue] as? String
            else { return nil }

            self.startTime = startTime
            self.endTime = endTime
        }

        func toDictionary() -> [String: Any] {
            [
                CodingKeys.startTime.rawValue: startTime,
                CodingKeys.endTime.rawValue: endTime
            ]
        }
    }
}
