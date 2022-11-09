//
//  UIApplication+Extensions.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .forEach {
                $0.windows
                    .filter { $0.isKeyWindow }
                    .first?
                    .endEditing(force)
            }
    }
}
