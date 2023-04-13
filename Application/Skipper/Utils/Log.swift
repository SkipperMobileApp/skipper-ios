//
//  Log.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

/// Wrapper for the logging system in the app.
///
/// You can add additional methods for different levels of logging as needed.
struct Log {
    /// Logs error message.
    static func error(
        _ message: String,
        filename: String = #file,
        line: Int = #line,
        funcname: String = #function
    ) {
        Log.console(message, prefix: "ERROR", filename: filename, line: line, funcname: funcname)
    }

    /// Logs to console only.
    static func console<T>(
        _ object: T,
        prefix: String = "",
        filename: String = #file,
        line: Int = #line,
        funcname: String = #function
    ) {
        let prefix = prefix.isEmpty ? "" : "\(prefix) -> "
        print(
            "\(prefix)\(NSDate()): \((filename as NSString).lastPathComponent)(\(line)) \(funcname):\(object)\n"
        )
    }
}
