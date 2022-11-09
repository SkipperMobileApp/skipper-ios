//
//  SplashViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

class SplashViewModel {
    var didFinish: ((_ isSuccess: Bool) -> Void)?

    private let session: AppSession

    init(session: AppSession) {
        self.session = session
    }

    func tryLogin() {
        delay(1.0) { [weak self] in
            self?.didFinish?(false)
        }
    }
}
