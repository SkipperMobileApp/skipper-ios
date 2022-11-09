//
//  AuthViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
    var didLogin: (() -> Void)?

    private let session: AppSession

    init(session: AppSession) {
        self.session = session
    }

    func login() {
        delay(1.0) { [weak self] in
            self?.didLogin?()
        }
    }
}
