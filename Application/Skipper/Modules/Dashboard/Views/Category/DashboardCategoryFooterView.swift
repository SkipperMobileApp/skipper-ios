//
//  DashboardCategoryFooterView.swift
//  Skipper
//
//  Created by Denis Kovalev on 03.01.2023.
//

import Combine
import Foundation
import Reusable
import UIKit

class DashboardCategoryFooterView: SetupableCollectionReusableView, Reusable {
    // MARK: - UI Controls

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = R.color.primary24()
        pageControl.currentPageIndicatorTintColor = R.color.brandPrimary()
        pageControl.hidesForSinglePage = true
        return pageControl
    }()

    // MARK: - Properties

    var numberOfPages: Int {
        get {
            pageControl.numberOfPages
        }
        set {
            pageControl.numberOfPages = newValue
        }
    }

    private var subscription: AnyCancellable?

    // MARK: - UI Lifecycle

    override func setup() {
        super.setup()

        addSubview(pageControl)

        pageControl.applyConstraints(
            .centerX(to: self, attribute: .centerX),
            .centerY(to: self, attribute: .centerY),
            .height(to: self, attribute: .height),
            .leading(to: self, attribute: .leading, constant: 24, equality: .greaterThanOrEqual),
            .trailing(to: self, attribute: .trailing, constant: -24, equality: .lessThanOrEqual)
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        subscription?.cancel()
        subscription = nil
    }

    // MARK: - UI Methods

    func configureWith(numberOfPages: Int, currentPagePublisher: AnyPublisher<Int, Never>) {
        self.numberOfPages = numberOfPages

        subscription?.cancel()
        subscription = currentPagePublisher
            .removeDuplicates()
            .sink { [weak self] page in
                self?.pageControl.currentPage = page
            }
    }
}
