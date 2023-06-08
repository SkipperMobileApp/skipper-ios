//
//  BookedLesson.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2023.
//

import Foundation

struct BookedLesson {
    let id: String
    let userId: String
    let mentorId: String
    let lessonId: String

    let name: String
    let description: String

    let type: LessonType

    let date: Date
    let time: String
    let duration: LessonDuration

    let contact: UserContactType
}
