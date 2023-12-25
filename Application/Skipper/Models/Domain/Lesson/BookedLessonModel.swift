//
//  BookedLessonModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2023.
//

import Foundation

struct BookedLessonModel {
    let id: String
    let userId: String
    let mentorId: String
    let lessonId: String

    let name: String
    let description: String

    let type: LessonType

    let dateTime: Date
    let duration: LessonDuration

    let contact: UserContactType
}
