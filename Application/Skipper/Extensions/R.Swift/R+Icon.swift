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

        static let eyeSlashed = UIImage(systemName: "eye.slash.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let home = UIImage(systemName: "house")!.withRenderingMode(.alwaysTemplate)

        static let search = UIImage(systemName: "magnifyingglass")!
            .withRenderingMode(.alwaysTemplate)

        static let profile = UIImage(systemName: "person.crop.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let like = UIImage(systemName: "hand.thumbsup.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let star = UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysTemplate)

        static let disclosure = UIImage(systemName: "chevron.right")!
            .withRenderingMode(.alwaysTemplate)

        static let educationCircle = UIImage(systemName: "graduationcap.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let briefCaseCircle = UIImage(systemName: "briefcase.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let starCircle = UIImage(systemName: "star.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let arrowRight = UIImage(systemName: "arrowtriangle.forward.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let trash = UIImage(systemName: "trash.fill")!.withRenderingMode(.alwaysTemplate)

        static let chatCircle = R.image.icChatCircle()!

        static let clockCircle = UIImage(systemName: "clock.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let dollarCircle = UIImage(systemName: "dollarsign.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let checklist = UIImage(systemName: "checklist")!.withRenderingMode(.alwaysTemplate)

        static let cameraCircle = UIImage(systemName: "camera.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let profileCircle = UIImage(systemName: "person.crop.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let lockCircle = UIImage(systemName: "lock.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let bellCircle = UIImage(systemName: "bell.circle.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let plus = UIImage(systemName: "plus")!
            .withRenderingMode(.alwaysTemplate)

        static let checkmark = UIImage(systemName: "checkmark")!
            .withRenderingMode(.alwaysTemplate)

        static let checkboxOn = UIImage(systemName: "checkmark.square.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let checkboxOff = UIImage(systemName: "square")!
            .withRenderingMode(.alwaysTemplate)

        static let cross = UIImage(systemName: "xmark")!
            .withRenderingMode(.alwaysTemplate)

        static let report = UIImage(systemName: "exclamationmark.octagon.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let chat = UIImage(systemName: "message")!
            .withRenderingMode(.alwaysTemplate)

        static let chatFill = UIImage(systemName: "message.fill")!
            .withRenderingMode(.alwaysTemplate)

        static let attachment = UIImage(systemName: "paperclip")!
            .withRenderingMode(.alwaysTemplate)

        static let sendMessage = UIImage(systemName: "paperplane")!
            .withRenderingMode(.alwaysTemplate)

        static let share = UIImage(systemName: "square.and.arrow.up")!
            .withRenderingMode(.alwaysTemplate)
    }
}
