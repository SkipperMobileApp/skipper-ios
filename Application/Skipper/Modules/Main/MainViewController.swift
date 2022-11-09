//
//  MainViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import UIKit

class MainViewController: UIViewController {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        return label
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?

    // MARK: - Properties

    private let viewModel: MainViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: MainViewModel) {
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        label.frame = view.bounds
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(label)
    }
}
