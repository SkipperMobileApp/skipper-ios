//
//  BookingViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 07.01.2023.
//

import Foundation
import UIKit

class BookingViewController: UIViewController {
    // MARK: - Output

    var didFinish: (() -> Void)?
    var didFinishBooking: (() -> Void)?

    // MARK: - Properties

    private let viewModel: BookingViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: BookingViewModel) {
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
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""

        let controller = BookingPageViewController(viewModel: viewModel)

        controller.didFinishBooking = { [weak self] in
            self?.didFinishBooking?()
        }

        view.addSubview(controller.view)
        controller.view.applyConstraints(.fit(in: view.safeAreaLayoutGuide))

        addChild(controller)
        controller.didMove(toParent: self)
    }

    private func bindViewModelActions() {}
}
