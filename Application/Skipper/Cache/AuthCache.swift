//
//  AuthCache.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.12.2022.
//

import Foundation

protocol AuthCache: AnyObject {
    var currentUser: AuthUserCacheModel? { get set }

    func clear()
}
