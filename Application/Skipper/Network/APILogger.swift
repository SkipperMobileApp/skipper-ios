//
//  APILogger.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Alamofire
import Foundation

class APILogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️ Request Started: \(request)
        ⚡️ Body Data: \(body)
        """
        Log.console(message)
    }

    func request<Value>(_: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        Log.console("⚡️ Response Received: \(response.debugDescription)")
    }
}
