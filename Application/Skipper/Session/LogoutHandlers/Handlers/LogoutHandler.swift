//
//  LogoutHandler.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.12.2022.
//

import Foundation

protocol LogoutHandler {
    func logout() async throws
}
