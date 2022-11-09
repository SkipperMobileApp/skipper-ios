//
//  ExampleMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

struct ExampleMapper {
    static func apiToDomain(_ model: ExampleAPIModel) -> ExampleModel {
        .init(id: model.id, value: model.value)
    }

    static func dbToDomain(_ model: ExampleDBModel) -> ExampleModel {
        .init(id: model.id.uuidString, value: model.value)
    }
}
