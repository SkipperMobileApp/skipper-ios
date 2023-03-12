//
//  CloudView.swift
//  Skipper
//
//  Created by Denis Kovalev on 05.01.2023.
//

import UIKit

/// A protocol to realize the items matching to cloud view
protocol CloudItem where Self: UIControl {
    func sizeThatFits(_ size: CGSize) -> CGSize
}

/// A protocol for representing the cloud view actions
protocol CloudViewDelegate: AnyObject {
    /// Called when the cloud item was tapped
    func cloudView(_ view: CloudView, didTapItem item: CloudItem, at index: Int)
    /// Called when the selected indexes were changed
    func cloudView(_ view: CloudView, didSelectItemsAt indexes: IndexSet)
}

/// A view, which represents the container for items to group them sequently with parameters
class CloudView: SetupableView {
    // MARK: - Definitions

    /// Layout parameters for view
    struct Layout {
        /// Item sizing attribures
        struct Attributes {
            /// Represents the content alignment directions
            enum Alignment {
                case left, center, right
            }

            let insets: UIEdgeInsets
            let rowSpace: CGFloat
            let itemSpace: CGFloat
            let itemHeight: CGFloat
            let alignment: Alignment
        }

        let width: CGFloat
        let height: CGFloat
        let rows: [[CGFloat]]
        let attributes: Attributes
    }

    // MARK: - Properties and variables

    override var intrinsicContentSize: CGSize {
        return CGSize(width: layout?.width ?? 0.0, height: layout?.height ?? 0.0)
    }

    private var layout: Layout?
    private(set) var items: [CloudItem] = []

    private(set) var isSelectionEnabled = false
    private(set) var isResetItemEnabled = false
    private(set) var maxSelectedItems: Int?
    private(set) var selectedIndexes = IndexSet()

    weak var delegate: CloudViewDelegate?

    // MARK: - UI Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let layout = layout else { return }

        var rowY: CGFloat = layout.attributes.insets.top
        var viewIndex = 0

        for row in layout.rows {
            var viewX: CGFloat = layout.attributes.insets.left

            switch layout.attributes.alignment {
            case .left: viewX = layout.attributes.insets.left
            case .center: viewX = (layout.width - rowWidth(row, attributes: layout.attributes)) / 2.0
            case .right: viewX = layout.width - rowWidth(row, attributes: layout.attributes) - layout.attributes.insets.right
            }

            for width in row {
                let view = items[viewIndex]
                view.frame = CGRect(x: viewX, y: rowY, width: width, height: layout.attributes.itemHeight)
                viewIndex += 1
                viewX += width + layout.attributes.itemSpace
            }
            rowY += layout.attributes.itemHeight + layout.attributes.rowSpace
        }
    }

    // MARK: - Initialization

    /// Fills the view with CloudItem instances based on precalculated Layout
    func updateWith(
        _ items: [CloudItem],
        layout: Layout,
        isSelectionEnabled: Bool = false,
        maxSelectedItems: Int? = nil,
        selectedIndexes: IndexSet = IndexSet(),
        isResetItemEnabled: Bool = false
    ) {
        self.layout = layout
        self.items.forEach { $0.removeFromSuperview() }
        self.items = items
        self.isSelectionEnabled = isSelectionEnabled
        self.maxSelectedItems = maxSelectedItems
        self.isResetItemEnabled = isResetItemEnabled

        var selectedIndexes = selectedIndexes
        if let maxSelectedItems = maxSelectedItems, maxSelectedItems < selectedIndexes.count {
            selectedIndexes = IndexSet(selectedIndexes.dropLast(selectedIndexes.count - maxSelectedItems))
        }
        self.selectedIndexes = selectedIndexes

        for (index, item) in items.enumerated() {
            item.isSelected = isSelectionEnabled && selectedIndexes.contains(index)
            item.addTarget(self, action: #selector(tapItem(_:)), for: .touchUpInside)
            addSubview(item)
        }

        updateDisabledState()
        invalidateIntrinsicContentSize()
    }

    // MARK: - Layout

    /// Calculates layout
    ///
    /// - Parameters:
    ///   - items: array of CloudItem
    ///   - attributes: desired Layout.Attributes
    ///   - width: view width
    ///
    /// - Returns: Layout instance
    class func calculateLayout(for items: [CloudItem], attributes: Layout.Attributes, width: CGFloat) -> Layout {
        var rows: [[CGFloat]] = []
        var row: [CGFloat] = []

        let availableWidth = width - attributes.insets.left - attributes.insets.right

        for item in items {
            let itemWidth = item.sizeThatFits(CGSize(width: availableWidth, height: attributes.itemHeight)).width

            var estimatedRow = row
            estimatedRow.append(itemWidth)
            if rowWidth(estimatedRow, attributes: attributes) > availableWidth {
                rows.append(row)
                row = [itemWidth]
            } else {
                row = estimatedRow
            }
        }
        rows.append(row)

        let height = attributes.itemHeight * CGFloat(rows.count)
            + attributes.rowSpace * CGFloat(rows.count - 1)
            + attributes.insets.top + attributes.insets.bottom

        return Layout(width: width, height: height, rows: rows, attributes: attributes)
    }

    private func updateDisabledState() {
        if isSelectionEnabled, let maxSelectedItems = maxSelectedItems, selectedIndexes.count >= maxSelectedItems {
            items.forEach { $0.isEnabled = $0.isSelected ? true : false }
            if isResetItemEnabled {
                items.first?.isEnabled = true
            }
        } else {
            items.forEach { $0.isEnabled = true }
        }
    }

    // MARK: - UI Callbacks

    @objc private func tapItem(_ sender: UIControl) {
        guard let index = items.firstIndex(where: { $0 == sender }) else { return }

        delegate?.cloudView(self, didTapItem: sender as! CloudItem, at: index)

        if isSelectionEnabled {
            if isResetItemEnabled, !sender.isSelected {
                if index == 0 {
                    selectedIndexes.removeAll()
                    items.forEach { $0.isSelected = false }
                } else {
                    selectedIndexes.remove(0)
                    items.first?.isSelected = false
                }
            }

            if sender.isSelected {
                sender.isSelected = false
                selectedIndexes.remove(index)
            } else {
                sender.isSelected = true
                selectedIndexes.insert(index)
            }

            updateDisabledState()

            delegate?.cloudView(self, didSelectItemsAt: selectedIndexes)
        }
    }
}

/// Calculates the row width for row items with attributes
///
/// - Parameters:
///   - row: Row items widths
///   - attributes: Cloud view layout attributes
///
/// - Returns: The supposed row width
private func rowWidth(_ row: [CGFloat], attributes: CloudView.Layout.Attributes) -> CGFloat {
    guard !row.isEmpty else { return 0.0 }
    return row.reduce(0.0) { $0 + $1 } + CGFloat(row.count - 1) * attributes.itemSpace
}
