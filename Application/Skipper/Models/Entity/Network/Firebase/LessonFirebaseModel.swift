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
    let slots: [Int: [String]]
    let types: [String]

    init(
        id: String,
        mentorId: String,
        title: String,
        brief: String,
        durations: [String],
        slots: [Int: [String]],
        types: [String]
    ) {
        self.id = id
        self.mentorId = mentorId
        self.title = title
        self.brief = brief
        self.durations = durations
        self.slots = slots
        self.types = types
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
    }

    init?(_ dict: [String: Any], id: String) {
        guard let mentorId = dict[CodingKeys.mentorId.rawValue] as? String,
              let title = dict[CodingKeys.title.rawValue] as? String,
              let brief = dict[CodingKeys.brief.rawValue] as? String,
              let durations = dict[CodingKeys.durations.rawValue] as? [String],
              let slots = dict[CodingKeys.slots.rawValue] as? [String: [String]],
              let types = dict[CodingKeys.types.rawValue] as? [String]
        else { return nil }

        self.id = id
        self.mentorId = mentorId
        self.title = title
        self.brief = brief
        self.durations = durations
        self.slots = slots.reduce([Int: [String]]()) { acc, element in
            guard let intKey = Int(element.key) else { return acc }

            var acc = acc
            acc[intKey] = element.value
            return acc
        }
        self.types = types
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.mentorId.rawValue: mentorId,
            CodingKeys.title.rawValue: title,
            CodingKeys.brief.rawValue: brief,
            CodingKeys.durations.rawValue: durations,
            CodingKeys.slots.rawValue: slots.reduce([String: [String]]()) { acc, element in
                var acc = acc
                acc[String(element.key)] = element.value
                return acc
            },
            CodingKeys.types.rawValue: types
        ]
    }
}
