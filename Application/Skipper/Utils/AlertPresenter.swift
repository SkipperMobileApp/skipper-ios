//
//  AlertPresenter.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import UIKit

class AlertPresenter {
    /// Presents `alert` on `controller`
    class func presentAlert(alert: UIAlertController, controller: UIViewController) {
        controller.present(alert, animated: true, completion: nil)
    }

    /// Presents alert with one button
    class func presentSimpleAlert(_ title: String? = nil,
                                  message: String? = nil,
                                  controller: UIViewController,
                                  buttonText: String = R.string.localizable.alertOk(),
                                  action: (() -> Void)? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: buttonText, style: .default, handler: { _ in
            action?()
        })
        alert.addAction(action)

        AlertPresenter.presentAlert(alert: alert, controller: controller)
    }

    /// Presents alert with two buttons
    class func present2ButtonAlert(_ title: String? = nil,
                                   message: String? = nil,
                                   controller: UIViewController,
                                   button1Text: String,
                                   button2Text: String,
                                   action1: (() -> Void)? = nil,
                                   action2: (() -> Void)? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: button1Text, style: .default, handler: { _ in
            action1?()
        })
        let action2 = UIAlertAction(title: button2Text, style: .default, handler: { _ in
            action2?()
        })
        alert.addAction(action1)
        alert.addAction(action2)
        AlertPresenter.presentAlert(alert: alert, controller: controller)
    }
}
