//
//  MainTabBarViewController.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.12.2022.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    // MARK: - Output

    var didFinish: (() -> Void)?
    var didSelectTab: ((Tab) -> Void)?

    // MARK: - Properties

    private let viewModel: MainTabBarViewModel

    // MARK: - Initialization

    deinit {
        Log.console("")
        didFinish?()
    }

    init(viewModel: MainTabBarViewModel) {
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
        setupTabBarAppearance()

        bindViewModelActions()
    }

    // MARK: - UI Methods

    private func setupUI() {
        view.backgroundColor = R.color.themeBackground()
    }

    private func bindViewModelActions() {
        viewModel.didFail = { [weak self] error in
            guard let self = self else { return }

            AlertPresenter.presentSimpleAlert("Ошибка", message: error.localizedDescription, controller: self)
        }
    }
}

// MARK: - Tabs

extension MainTabBarViewController {
    enum Tab: Int, CaseIterable {
        case dashboard, myLessons, profile
    }

    private func setupTabBarAppearance() {
        let barBackgroundColor = R.color.themePrimary()
        let itemNormalColor = R.color.primary54()!
        let itemSelectedColor = R.color.brandPrimary()!

        let itemTextNormalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: itemNormalColor,
            .font: R.typo.caption!
        ]

        let itemTextSelectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: itemSelectedColor,
            .font: R.typo.caption!
        ]

        // Tab Bar appearance

        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = barBackgroundColor

        // Tab Bar Item appearance

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = itemNormalColor
        itemAppearance.normal.titleTextAttributes = itemTextNormalAttributes
        itemAppearance.selected.iconColor = itemSelectedColor
        itemAppearance.selected.titleTextAttributes = itemTextSelectedAttributes
        itemAppearance.disabled.titleTextAttributes = itemAppearance.normal.titleTextAttributes
        itemAppearance.focused.titleTextAttributes = itemAppearance.selected.titleTextAttributes

        appearance.compactInlineLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.stackedLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelect _: UIViewController) {
        didSelectTab?(Tab.allCases[selectedIndex])
    }
}
