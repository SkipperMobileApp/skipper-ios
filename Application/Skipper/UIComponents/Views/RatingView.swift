//
//  RatingView.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2024.
//

import Foundation
import UIKit

class RatingView: SetupableView {
    // MARK: - UI Controls

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 1
        return stackView
    }()

    override func setup() {
        super.setup()

        addSubview(stackView)
        stackView.applyConstraints(.fit(in: self))
    }

    func configureWith(rating: Double) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        (0 ..< 5)
            .map { index in
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true

                switch rating - Double(index) {
                case ..<0.25:
                    imageView.image = UIImage(systemName: "star.fill")
                    imageView.tintColor = R.color.primary38()
                case 0.25 ..< 0.75:
                    imageView.image = UIImage(systemName: "star.leadinghalf.filled")
                    imageView.tintColor = R.color.brandPrimary()
                case 0.75...:
                    imageView.image = UIImage(systemName: "star.fill")
                    imageView.tintColor = R.color.brandPrimary()
                default: break
                }

                return imageView
            }
            .forEach {
                stackView.addArrangedSubview($0)
            }
    }
}
