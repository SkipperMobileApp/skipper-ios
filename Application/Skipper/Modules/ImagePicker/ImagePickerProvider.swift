//
//  ImagePickerProvider.swift
//  HRAutomation
//
//  Created by Denis Kovalev on 20.12.2022.
//

import Foundation
import UIKit

class ImagePickerProvider {
    enum `Type` {
        case camera, photos
    }

    let type: `Type`
    let didSelectImage: (UIImage?) -> Void

    init(type: Type, didSelectImage: @escaping (UIImage?) -> Void) {
        self.type = type
        self.didSelectImage = didSelectImage
    }
}
