//
//  FIrebaseModel.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 19.11.2022.
//

import Foundation

protocol FirebaseResponseModel {
    init?(_ dict: [String: Any], id: String)
}

protocol FirebaseRequestModel {
    func toDictionary() -> [String: Any]
}

protocol FirebaseModel: FirebaseRequestModel, FirebaseResponseModel {}
