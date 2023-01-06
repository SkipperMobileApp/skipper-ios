//
//  MentorProfileResumeView.swift
//  Skipper
//
//  Created by Denis Kovalev on 06.01.2023.
//

import Foundation
import UIKit

class MentorProfileResumeView: SetupableView {
    // MARK: - UI Controls

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    // MARK: - UI Methods

    override func setup() {
        super.setup()

        addSubview(stackView)
        stackView.applyConstraints(.fit(in: self))
    }

    func configureWith(items: [ViewModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        items
            .map {
                let view = MentorProfileResumeTypeItem()
                view.configureWith(
                    title: $0.title,
                    icon: $0.image,
                    items: $0.items.map { .init(title: $0.title, subtitle: $0.subtitle) }
                )
                return view
            }
            .forEach {
                stackView.addArrangedSubview($0)
            }
    }
}

extension MentorProfileResumeView {
    struct ViewModel {
        struct Item {
            let title: String
            let subtitle: String
        }

        let title: String
        let image: UIImage
        let items: [Item]
    }
}
