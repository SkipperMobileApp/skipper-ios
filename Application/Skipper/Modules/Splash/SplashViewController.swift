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
        label.text = Strings.splashText()
        label.font = R.typo.promo2
        label.textColor = R.color.primary100()
        label.textAlignment = .center
        return label
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

        label.applyConstraints(
            .centerX(to: view, attribute: .centerX),
            .centerY(to: view, attribute: .centerY, constant: -20)
        )
    }

    private func bindViewModelActions() {
        viewModel.didFinish = { [weak self] isSuccess in
            self?.didFinish?(isSuccess)
        }
    }
}
