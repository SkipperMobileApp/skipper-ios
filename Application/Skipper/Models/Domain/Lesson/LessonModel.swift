//
//  LessonModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.01.2023.
//

import Foundation

struct LessonModel {
    let id: String
    let mentorId: String
    let title: String
    let brief: String
    let description: String
    let appointmentDate: Date
    let durations: [LessonDuration]
    let costTable: [LessonDuration: Int]
    let slots: [Int: [String]]
    let types: [LessonType]
}
