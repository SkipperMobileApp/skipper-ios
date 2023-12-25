//
//  BookedLessonFirebaseModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 24.09.2023.
//

import Foundation

struct BookedLessonFirebaseModel {
    let id: String
    let userId: String
    let mentorId: String
    let lessonId: String

    let name: String
    let description: String

    let type: String

    let dateTime: String
    let duration: String

    let contact: String

    init(
        id: String,
        userId: String,
        mentorId: String,
        lessonId: String,
        name: String,
        description: String,
        type: String,
        dateTime: String,
        duration: String,
        contact: String
    ) {
        self.id = id
        self.userId = userId
        self.mentorId = mentorId
        self.lessonId = lessonId
        self.name = name
        self.description = description
        self.type = type
        self.dateTime = dateTime
        self.duration = duration
        self.contact = contact
    }
}

extension BookedLessonFirebaseModel: FirebaseModel {
    enum CodingKeys: String {
        case userId
        case mentorId
        case lessonId
        case name
        case description
        case type
        case dateTime = "date_time"
        case duration
        case contact
    }

    init?(_ dict: [String: Any], id: String) {
        guard let userId = dict[CodingKeys.userId.rawValue] as? String,
              let mentorId = dict[CodingKeys.mentorId.rawValue] as? String,
              let lessonId = dict[CodingKeys.lessonId.rawValue] as? String,
              let name = dict[CodingKeys.name.rawValue] as? String,
              let description = dict[CodingKeys.description.rawValue] as? String,
              let type = dict[CodingKeys.type.rawValue] as? String,
              let dateTime = dict[CodingKeys.dateTime.rawValue] as? String,
              let duration = dict[CodingKeys.duration.rawValue] as? String,
              let contact = dict[CodingKeys.contact.rawValue] as? String
        else {
            return nil
        }

        self.id = id
        self.userId = userId
        self.mentorId = mentorId
        self.lessonId = lessonId
        self.name = name
        self.description = description
        self.type = type
        self.dateTime = dateTime
        self.duration = duration
        self.contact = contact
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.userId.rawValue: userId,
            CodingKeys.mentorId.rawValue: mentorId,
            CodingKeys.lessonId.rawValue: lessonId,
            CodingKeys.name.rawValue: name,
            CodingKeys.description.rawValue: description,
            CodingKeys.type.rawValue: type,
            CodingKeys.dateTime.rawValue: dateTime,
            CodingKeys.duration.rawValue: duration,
            CodingKeys.contact.rawValue: contact
        ]
    }
}
