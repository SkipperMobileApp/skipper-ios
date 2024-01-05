//
//  ImagePreviewViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2024.
//

import Combine
import Foundation
import UIKit

class ImagePreviewViewController: UIViewController {
    // MARK: - Definitions

    enum ScreenState {
        case loading(progress: Int)
        case image(image: UIImage)
    }

    // MARK: - UI Controls

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 2
        gesture.addTarget(self, action: #selector(tapZoomAction))
        imageView.addGestureRecognizer(gesture)

        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.maximumZoomScale = 5
        scrollView.minimumZoomScale = 1
        scrollView.backgroundColor = R.color.themeBackground()

        scrollView.delegate = self

        return scrollView
    }()

    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.startLoading()
        view.tintColor = R.color.primary87()
        return view
    }()

    // MARK: - Output

    var didFinish: (() -> Void)?
    var didTapShare: ((_ image: UIImage) -> Void)?

    // MARK: - Properties

    private var subscriptions = Set<AnyCancellable>()

    private let viewModel: ImagePreviewViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: ImagePreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        bindViewModelActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadImage()
    }

    // MARK: - UI Methods

    private func setupUI() {
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = .init(
            image: R.icon.share,
            style: .plain,
            target: self,
            action: #selector(shareAction)
        )

        view.backgroundColor = R.color.themeBackground()

        view.addSubview(scrollView)
        view.addSubview(loadingView)
        scrollView.addSubview(imageView)

        scrollView.applyConstraints(
            .fit(in: view.safeAreaLayoutGuide)
        )

        loadingView.applyConstraints(.center(in: view.safeAreaLayoutGuide))
    }

    private func bindViewModelActions() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateScreenState(state)
            }
            .store(in: &subscriptions)
    }

    private func updateScreenState(_ state: ScreenState) {
        switch state {
        case let .loading(progress):
            updateLoadingProgress(progress)
            updateViewsVisibility(hasContent: false)
        case let .image(image):
            imageView.image = image
            updateViewsVisibility(hasContent: true)
            adjustImageViewSize()
        }
    }

    private func updateViewsVisibility(hasContent: Bool) {
        scrollView.isHidden = !hasContent
        loadingView.isHidden = hasContent
    }

    private func adjustImageViewSize() {
        imageView.frame = .init(origin: .zero, size: scrollView.frame.size)
    }

    private func updateLoadingProgress(_ progress: Int) {
        loadingView.updateProgress(progress)
    }

    // MARK: - UI Callbacks

    @objc private func shareAction() {
        guard let image = viewModel.image else { return }
        didTapShare?(image)
    }

    @objc private func tapZoomAction(gesture: UITapGestureRecognizer) {
        scrollView.setZoomScale(scrollView.zoomScale + 1, animated: true)
    }
}

extension ImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
