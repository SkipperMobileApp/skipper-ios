//
//  R+Icon.swift
//  Skipper
//
//  Created by Denis Kovalev on 21.11.2022.
//

import UIKit.UIImage

extension R {
    enum icon {
        static let eye = UIImage(systemName: "eye.fill")!.withRenderingMode(.alwaysTemplate)

        static let eyeSlashed = UIImage(systemName: "eye.slash.fill")!.withRenderingMode(.alwaysTemplate)

        static let home = UIImage(systemName: "house")!.withRenderingMode(.alwaysTemplate)

        static let search = UIImage(systemName: "magnifyingglass")!.withRenderingMode(.alwaysTemplate)

        static let profile = UIImage(systemName: "person.crop.circle.fill")!.withRenderingMode(.alwaysTemplate)

        static let like = UIImage(systemName: "hand.thumbsup.fill")!.withRenderingMode(.alwaysTemplate)

        static let star = UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysTemplate)

        static let disclosure = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)

        static let educationCircle = UIImage(systemName: "graduationcap.circle.fill")!.withRenderingMode(.alwaysTemplate)

        static let briefCaseCircle = UIImage(systemName: "briefcase.circle.fill")!.withRenderingMode(.alwaysTemplate)

        static let starCircle = UIImage(systemName: "star.circle.fill")!.withRenderingMode(.alwaysTemplate)

        static let arrowRight = UIImage(systemName: "arrowtriangle.forward.fill")!.withRenderingMode(.alwaysTemplate)
    }
}
