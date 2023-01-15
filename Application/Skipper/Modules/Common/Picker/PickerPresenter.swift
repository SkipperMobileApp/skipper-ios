//
//  PickerPresenter.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation
import UIKit

protocol PickerPresenterDelegate: AnyObject {
    func pickerPresenter(_ presenter: PickerPresenter, didSelectItemAtIndex index: Int)
}

class PickerPresenter {
    typealias PickerData = PickerViewController.PickerData

    weak var delegate: PickerPresenterDelegate?

    private var currentPicker: PickerViewController?

    func presentPicker(pickerData: PickerData) {
        dismiss(animated: false)

        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let controller = window.rootViewController
        else {
            return
        }

        let picker = PickerViewController(pickerData: pickerData)

        picker.didTapCancel = { [weak self] in
            self?.dismiss()
        }

        picker.didSelectItem = { [weak self] index in
            guard let self = self else { return }
            self.delegate?.pickerPresenter(self, didSelectItemAtIndex: index)
        }

        picker.modalTransitionStyle = .crossDissolve
        picker.modalPresentationStyle = .overCurrentContext

        controller.present(picker, animated: true)

        currentPicker = picker
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if currentPicker == nil {
            completion?()
            return
        }

        currentPicker?.dismiss(animated: animated, completion: completion)
        currentPicker = nil
    }
}
