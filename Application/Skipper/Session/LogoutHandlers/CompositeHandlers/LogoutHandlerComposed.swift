//
//  LogoutHandlerComposed.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.12.2022.
//

import Foundation

@resultBuilder
enum LogoutHandlerComposed {
    static func buildBlock(_ handlers: LogoutHandler...) -> [LogoutHandler] {
        Array(handlers)
    }
}
