//
//  ChatFirebaseModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 26.12.2023.
//

import Foundation

struct ChatFirebaseModel {
    let id: String
    let lastMessage: String
    let lastUpdateDate: Int
    let participants: [String]

    init(id: String, lastMessage: String, lastUpdateDate: Int, participants: [String]) {
        self.id = id
        self.lastMessage = lastMessage
        self.lastUpdateDate = lastUpdateDate
        self.participants = participants
    }
}

extension ChatFirebaseModel: FirebaseModel {
    enum CodingKeys: String {
        case lastMessage = "last_message"
        case lastUpdateDate = "last_update_date"
        case participants
    }

    init?(_ dict: [String: Any], id: String) {
        guard let lastMessage = dict[CodingKeys.lastMessage.rawValue] as? String,
              let lastUpdateDate = dict[CodingKeys.lastUpdateDate.rawValue] as? Int,
              let participants = dict[CodingKeys.participants.rawValue] as? [String]
        else {
            return nil
        }

        self.id = id
        self.lastMessage = lastMessage
        self.lastUpdateDate = lastUpdateDate
        self.participants = participants
    }

    func toDictionary() -> [String: Any] {
        [
            CodingKeys.lastMessage.rawValue: lastMessage,
            CodingKeys.lastUpdateDate.rawValue: lastUpdateDate,
            CodingKeys.participants.rawValue: participants
        ]
    }
}
