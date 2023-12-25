//
//  PickerPresenter.swift
//  Skipper
//
//  Created by Denis Kovalev on 08.01.2023.
//

import Foundation
import UIKit

protocol ItemPickerDelegate: AnyObject {
    func itemPicker(_ presenter: PickerPresenter, didSelectItemAtIndex index: Int)
}

protocol TimeSlotsPickerDelegate: AnyObject {
    func timeSlotsPicker(
        _ presenter: PickerPresenter,
        didSelectStartTime startTime: Date,
        withEndTime endTime: Date
    )
}

class PickerPresenter {
    typealias ItemPickerData = ItemPickerViewController.PickerData
    typealias TimeSlotsPickerData = TimeSlotsPickerViewController.PickerData

    weak var itemDelegate: ItemPickerDelegate?
    weak var timeSlotsDelegate: TimeSlotsPickerDelegate?

    private var currentPicker: UIViewController?

    func presentItemPicker(pickerData: ItemPickerData, on viewController: UIViewController? = nil) {
        dismiss(animated: false)

        var controller: UIViewController! = viewController
        if controller == nil {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                  let rootController = window.rootViewController
            else {
                return
            }

            controller = rootController
        }

        let picker = ItemPickerViewController(pickerData: pickerData)

        picker.didTapCancel = { [weak self] in
            self?.dismiss()
        }

        picker.didSelectItem = { [weak self] index in
            guard let self = self else { return }
            self.itemDelegate?.itemPicker(self, didSelectItemAtIndex: index)
        }

        picker.modalTransitionStyle = .crossDissolve
        picker.modalPresentationStyle = .overCurrentContext

        controller.present(picker, animated: true)

        currentPicker = picker
    }

    func presentTimeSlotsPicker(pickerData: TimeSlotsPickerData) {
        dismiss(animated: false)

        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let controller = window.rootViewController
        else {
            return
        }

        let picker = TimeSlotsPickerViewController(pickerData: pickerData)

        picker.didTapCancel = { [weak self] in
            self?.dismiss()
        }

        picker.didSelectTimeSlot = { [weak self] startTime, endTime in
            guard let self = self else { return }
            self.timeSlotsDelegate?.timeSlotsPicker(
                self,
                didSelectStartTime: startTime,
                withEndTime: endTime
            )
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
