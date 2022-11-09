//
//  R+Extensions.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import UIKit

extension R {
    enum typo {
        /// System font, bold, 50 pt
        static let promo = UIFont.systemFont(ofSize: 50, weight: .bold)

        /// System font, medium, 20 pt
        static let header = UIFont.systemFont(ofSize: 20, weight: .medium)

        /// System font, regular, 16 pt
        static let body = UIFont.systemFont(ofSize: 16, weight: .regular)

        /// System font, regular, 12 pt
        static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
