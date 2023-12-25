//
//  LessonModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation

struct LessonModel {
    var id: String
    let mentorId: String
    let title: String
    let brief: String
    let description: String
    let durations: Set<LessonDuration>
    let slots: [Int: [LessonTimeSlot]]
    let types: Set<LessonType>
    let creationDate: Date
    let updationDate: Date

    struct LessonTimeSlot {
        let startTime: Date
        let endTime: Date
    }
}
