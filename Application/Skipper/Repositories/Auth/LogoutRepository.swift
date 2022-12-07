//
//  LogoutRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.12.2022.
//

import Foundation

protocol LogoutRepository {
    func signOut() async throws
}
