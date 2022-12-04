//
//  UserService.swift
//  Skipper
//
//  Created by Denis Kovalev on 23.11.2022.
//

import Foundation

protocol UserService: AnyObject {
    var currentUser: AuthUserModel? { get set }

    var isAuthenticated: Bool { get }
}

class UserServiceImpl: UserService {
    var currentUser: AuthUserModel?

    var isAuthenticated: Bool {
        currentUser != nil
    }
}
