//
//  SplashViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    // MARK: - UI Controls

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.splashText()
        label.font = R.typo.promo
        label.textColor = R.color.primary100()
        label.textAlignment = .center
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.bgSplash()
        return imageView
    }()

    // MARK: - Output

    var didFinish: ((_ isSuccess: Bool) -> Void)?

    // MARK: - Properties

    private let viewModel: SplashViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
    }

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelActions()

        viewModel.tryLogin()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()

        view.addSubview(label)
        view.addSubview(imageView)

        imageView.applyConstraints(.height(constant: 300),
                                   .leading(to: view, attribute: .leading),
                                   .trailing(to: view, attribute: .trailing),
                                   .centerY(to: view, attribute: .centerY))

        label.applyConstraints(.leading(to: view, attribute: .leading, constant: 10),
                               .trailing(to: view, attribute: .trailing, constant: -10),
                               .top(to: imageView, attribute: .bottom, constant: 30))
    }

    private func bindViewModelActions() {
        viewModel.didFinish = { [weak self] isSuccess in
            self?.didFinish?(isSuccess)
        }
    }
}
