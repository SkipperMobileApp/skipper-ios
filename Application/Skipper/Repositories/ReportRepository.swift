//
//  ReportRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Foundation

protocol ReportRepository {
    func sendReport(report: ReportMentorModel) async throws
}

class ReportRepositoryImpl: ReportRepository {
    private let database: FirestoreDatabase

    init(database: FirestoreDatabase) {
        self.database = database
    }

    func sendReport(report: ReportMentorModel) async throws {
        try await Task.sleep(for: .seconds(1))

        try await database.sendReport(report: ReportMapper.Mentor.domainToAPI(report))
    }
}
