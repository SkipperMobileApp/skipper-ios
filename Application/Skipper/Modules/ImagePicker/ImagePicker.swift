//
//  ImagePicker.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 20.12.2022.
//

import Foundation
import Photos
import PhotosUI
import UIKit

class ImagePicker: NSObject {
    private var provider: ImagePickerProvider?

    func presentPicker(provider: ImagePickerProvider, on controller: UIViewController) {
        self.provider = provider

        if provider.type == .camera {
            presentCameraPicker(on: controller)
            return
        }

        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited: presentPhotoPicker(on: controller)
        case .denied: showPermissionDeniedAlert(on: controller)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self, weak controller] status in
                guard let self = self, let controller = controller else { return }

                if status == .authorized {
                    DispatchQueue.main.async {
                        self.presentPhotoPicker(on: controller)
                    }
                }
            }
        default: return
        }
    }

    func showPermissionDeniedAlert(on controller: UIViewController) {
        let alert = UIAlertController(title: "Photo library permission denied",
                                      message: "Please, go to settings and enable it to choose photos from gallery",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Go to setting", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                      options: [:],
                                      completionHandler: nil)
        })

        controller.present(alert, animated: true)
    }
}

// MARK: - Camera

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentCameraPicker(on controller: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self

        controller.present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let image = info[.originalImage] as? UIImage else { return }

        provider?.didSelectImage(image)
    }
}

// MARK: - Photos library

extension ImagePicker: PHPickerViewControllerDelegate, PHPhotoLibraryAvailabilityObserver {
    func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {}

    private func presentPhotoPicker(on controller: UIViewController) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self

        PHPhotoLibrary.shared().register(self)

        controller.present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else {
            picker.dismiss(animated: true)
            return
        }

        guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
            picker.dismiss(animated: true) { [weak self] in
                self?.provider?.didSelectImage(nil)
            }
            return
        }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self, weak picker] image, error in

            if error != nil {
                DispatchQueue.main.async {
                    picker?.dismiss(animated: true) {
                        self?.provider?.didSelectImage(nil)
                    }
                }
                return
            }

            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    picker?.dismiss(animated: true) { [weak self] in
                        self?.provider?.didSelectImage(image)
                    }
                }
            }
        }
    }
}
