//
//  ReportMentorFirebaseModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Foundation

struct ReportMentorFirebaseModel {
    let id: String
    let userId: String
    let mentorId: String
    let mentorName: String
    let reportType: String
    let reportMessage: String

    init(
        id: String,
        userId: String,
        mentorId: String,
        mentorName: String,
        reportType: String,
        reportMessage: String
    ) {
        self.id = id
        self.userId = userId
        self.mentorId = mentorId
        self.mentorName = mentorName
        self.reportType = reportType
        self.reportMessage = reportMessage
    }
}

extension ReportMentorFirebaseModel: FirebaseModel {
    enum CodingKeys: String {
        case id
        case userId = "user_id"
        case mentorId = "mentor_id"
        case mentorName = "mentor_name"
        case reportType = "report_type"
        case reportMessage = "report_message"
    }

    init?(_ dict: [String: Any], id: String) {
        guard let userId = dict[CodingKeys.userId.rawValue] as? String,
              let mentorId = dict[CodingKeys.mentorId.rawValue] as? String,
              let mentorName = dict[CodingKeys.mentorName.rawValue] as? String,
              let reportType = dict[CodingKeys.reportType.rawValue] as? String,
              let reportMessage = dict[CodingKeys.reportMessage.rawValue] as? String
        else { return nil }

        self.id = id
        self.userId = userId
        self.mentorId = mentorId
        self.mentorName = mentorName
        self.reportType = reportType
        self.reportMessage = reportMessage
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.userId.rawValue: userId,
            CodingKeys.mentorId.rawValue: mentorId,
            CodingKeys.mentorName.rawValue: mentorName,
            CodingKeys.reportType.rawValue: reportType,
            CodingKeys.reportMessage.rawValue: reportMessage
        ]
    }
}
