//
//  UserModel.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 19.11.2022.
//

import Foundation

struct UserModel {
    var id: String
    var email: String

    var firstName: String
    var lastName: String
    var bio: String
    var post: String

    var imageUrl: String?

    let isMentor: Bool

    let contacts: [UserContactModel]
    let stats: UserStats
    let tags: [String]
    var lessons: [LessonModel]
    let resumeInfo: UserResumeInfo
}

extension UserModel {
    struct UserStats {
        let lessonsCount: Int
        let rating: Double
        let registrationDate: String
        let reviewsCount: Int
    }

    struct UserResumeInfo {
        let educationUnits: [UserResumeEducationUnit]
        let workUnits: [UserResumeWorkUnit]
        let achievementUnits: [UserResumeAchievmentUnit]
    }

    struct UserResumeEducationUnit {
        let name: String
        let startYear: Int
        let endYear: Int
        let degree: String
    }

    struct UserResumeWorkUnit {
        let name: String
        let startYear: Int
        let endYear: Int?
        let post: String
    }

    struct UserResumeAchievmentUnit {
        let name: String
        let year: Int
        let info: String
    }
}

typealias PaginatedUserModel = PaginatedModel<UserModel>
