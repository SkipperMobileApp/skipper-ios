//
//  ReportMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Foundation

enum ReportMapper {
    enum Mentor {
        static func domainToAPI(_ model: ReportMentorModel) -> ReportMentorFirebaseModel {
            .init(
                id: model.reportId ?? UUID().uuidString,
                userId: model.userId,
                mentorId: model.mentorId,
                mentorName: model.mentorName,
                reportType: model.reason.rawValue,
                reportMessage: model.text
            )
        }
    }
}
