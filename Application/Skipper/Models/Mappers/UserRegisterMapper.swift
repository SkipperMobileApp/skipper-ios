//
//  UserRegisterMapper.swift
//  Skipper
//
//  Created by Denis Kovalev on 04.12.2022.
//

import Foundation

enum UserRegisterMapper {
    static func domainToAPI(_ model: UserRegisterModel) -> UserRegisterAPIModel {
        .init(
            email: model.email,
            password: model.password,
            firstName: model.firstName,
            lastName: model.lastName
        )
    }
}
