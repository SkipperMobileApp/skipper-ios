//
//  ReportMentorModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Foundation

struct ReportMentorModel {
    var reportId: String?
    let userId: String
    let mentorId: String
    let mentorName: String
    let reason: ReportReason
    let text: String
}
