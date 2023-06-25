//
//  ReportReason.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.06.2023.
//

import Foundation

enum ReportReason: String {
    case fraud
    case offensiveBehaviour = "offensive_behaviour"
    case profileTroubles = "profile_troubles"
    case other
}
