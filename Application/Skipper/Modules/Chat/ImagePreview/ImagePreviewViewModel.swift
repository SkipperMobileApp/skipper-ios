//
//  ImagePreviewViewModel.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2024.
//

import Foundation
import Kingfisher
import UIKit

class ImagePreviewViewModel {
    @Event private(set) var errorEvent: Error?

    @Published private(set) var state: ScreenState = .loading(progress: 0)

    private let imageURL: URL
    private(set) var image: UIImage?

    init(imageURL: URL) {
        self.imageURL = imageURL
    }

    func loadImage() {
        state = .loading(progress: 0)
        KingfisherManager.shared.retrieveImage(
            with: imageURL,
            progressBlock: { [weak self] receivedSize, totalSize in
                let progress = Int((Double(receivedSize) / Double(totalSize)) * 100)
                self?.state = .loading(progress: progress)
            },
            completionHandler: { [weak self] result in
                guard let self else { return }

                switch result {
                case let .success(imageResult):
                    self.state = .image(image: imageResult.image)
                    self.image = imageResult.image
                case let .failure(error):
                    self.errorEvent = error
                }
            }
        )
    }
}

// MARK: - ViewModel

extension ImagePreviewViewModel {
    typealias ScreenState = ImagePreviewViewController.ScreenState
}
