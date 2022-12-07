//
//  AuthCacheImpl.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.12.2022.
//

import Foundation

class AuthCacheImpl: AuthCache {
    var currentUser: AuthUserCacheModel?

    func clear() {
        currentUser = nil
    }
}
