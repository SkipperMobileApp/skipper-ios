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
        label.textColor = R.color.primary87()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        label.frame = view.bounds
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.brandPrimary()
        view.addSubview(label)
    }

    private func bindViewModelActions() {
        viewModel.didFinish = { [weak self] isSuccess in
            self?.didFinish?(isSuccess)
        }
    }
}
