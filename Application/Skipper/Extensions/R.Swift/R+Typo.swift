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
        /// Montserrat Regular (400) 50 pt
        static let promo = R.font.montserratRegular(size: 27)

        /// SF Pro Regular (400) 32 pt
        static let promo2 = UIFont.systemFont(ofSize: 32, weight: .regular)

        /// Montserrat Bold (700) 16 pt
        static let header = R.font.montserratBold(size: 16)

        /// Montserrat SemiBold (700), 22 pt
        static let header2 = R.font.montserratSemiBold(size: 22)

        /// Montserrat Medium (500), 16 pt
        static let header3 = R.font.montserratMedium(size: 16)

        /// SF Pro Regular (400), 15 pt
        static let body = UIFont.systemFont(ofSize: 15, weight: .regular)

        /// SF Pro Regular (400) 17 pt
        static let body1 = UIFont.systemFont(ofSize: 17, weight: .regular)

        /// Montserrat Regular (400), 11 pt
        static let caption = R.font.montserratRegular(size: 11)
    }
}
