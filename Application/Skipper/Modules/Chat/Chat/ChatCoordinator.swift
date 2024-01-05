//
//  ChatCoordinator.swift
//  Skipper
//
//  Created by Denis Kovalev on 25.12.2023.
//

import Foundation
import UIKit

class ChatCoordinator: NavigationCoordinator {
    // MARK: - Output

    var didSelectChat: ((_ chatId: String, _ opponentId: String) -> Void)?
    var didFinish: (() -> Void)?

    // MARK: - Properties

    private let chatId: String
    private let opponentId: String

    private let imagePicker = ImagePicker()

    // MARK: - Initialization

    init(with router: NavigationRouter, chatId: String, opponentId: String) {
        self.chatId = chatId
        self.opponentId = opponentId

        super.init(with: router)

        let viewModel = ChatViewModel(chatId: chatId, opponentId: opponentId)
        let controller = ChatViewController(viewModel: viewModel)

        controller.didSelectImageAttachmentType = { [weak self, weak controller] provider in
            guard let self, let controller else { return }
            self.imagePicker.presentPicker(provider: provider, on: controller)
        }

        controller.didTapMessageImage = { [weak self] url in
            self?.showImagePreview(url: url)
        }

        controller.didFinish = { [weak self] in
            self?.didFinish?()
        }

        router.push(controller)
    }

    // MARK: - Routing

    private func showImagePreview(url: URL) {
        let viewModel = ImagePreviewViewModel(imageURL: url)
        let controller = ImagePreviewViewController(viewModel: viewModel)

        controller.didTapShare = { [weak self, weak controller] image in
            guard let self, let controller else { return }
            self.showSharingSheet(image: image, presentOnView: controller.view)
        }

        router.push(controller)
    }

    private func showSharingSheet(image: UIImage, presentOnView view: UIView) {
        let activityViewController = UIActivityViewController(
            activityItems: [ImageActivityItemSource(image: image)],
            applicationActivities: nil
        )

        activityViewController.popoverPresentationController?.sourceView = view

        router.present(activityViewController)
    }
}
