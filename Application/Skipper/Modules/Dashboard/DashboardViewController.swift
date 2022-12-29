//
//  DashboardViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 30.12.2022.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    // MARK: - Output

    var didFinish: (() -> Void)?

    // MARK: - Properties

    private let viewModel: DashboardViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: DashboardViewModel) {
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
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()
    }

    private func bindViewModelActions() {}
}
