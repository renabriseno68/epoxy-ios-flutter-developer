//  Created by Laura Skelton on 6/4/17.
//  Copyright © 2017 Airbnb. All rights reserved.

import UIKit

/// Configures an Epoxy view and handles adaptivity. Subclass this to set your content in `epoxySections()`.
open class EpoxyTableViewController: UIViewController {

  // MARK: Open

  open override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    setUpConstraints()
  }

  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setEpoxySectionsIfReady()
  }

  open var shouldPinUnderStatusBar: Bool {
    return false
  }

  /// Override this in your subclass to return your Epoxy sections
  open func epoxySections() -> [EpoxySection] {
    return []
  }

  /// Override this in your subclass to return the data IDs of any dividers you wish to hide.
  open func hiddenDividerDataIDs() -> [String] {
    return []
  }

  /// Returns a standard `TableView` by default. Override this to configure it differently.
  open func makeTableView() -> TableView {
    let tableView = TableView()

    tableView.rowDividerBuilder = {
      let divider = EpoxyDivider()
      divider.color = UIColor.lightGray
      divider.height = 1
      return divider
    }
    tableView.sectionHeaderDividerBuilder = {
      let divider = EpoxyDivider()
      divider.color = UIColor.clear
      divider.height = 0
      return divider
    }
    tableView.backgroundColor = .white

    tableView.rowDividerConfigurer = { [weak self] divider in
      guard let divider = divider as? EpoxyDivider else { return }
      if self?.traitCollection.horizontalSizeClass == .regular {
        divider.leadingPadding = 64
        divider.trailingPadding = 64
      } else {
        divider.leadingPadding = 24
        divider.trailingPadding = 24
      }
    }
    return tableView
  }

  // MARK: Public

  public var contentOffset: CGPoint? {
    return tableView.contentOffset
  }

  public func constrainTableViewBottom(to anchor: NSLayoutYAxisAnchor, constant c: CGFloat = 0) {
    bottomConstraint?.isActive = false
    bottomConstraint = tableView.bottomAnchor.constraint(equalTo: anchor, constant: c)
    bottomConstraint?.isActive = true
  }

  public lazy var tableView: TableView = {
    assert(self.isViewLoaded, "Accessed tableView before view was loaded.")
    return self.makeTableView()
  }()

  /// Updates the Epoxy view by calling the `epoxySections()` method. Optionally animated.
  public func updateData(animated: Bool) {
    if isViewLoaded && traitCollection.horizontalSizeClass != .unspecified {
      let sections = epoxySections()
      tableView.setSections(sections, animated: animated)
      tableView.hideBottomDivider(for: hiddenDividerDataIDs())
    }
  }

  // MARK: Private

  private var bottomConstraint: NSLayoutConstraint?

  private func setUpViews() {
    view.backgroundColor = .white
    view.addSubview(tableView)
    setEpoxySectionsIfReady()
  }

  private func setUpConstraints() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    if shouldPinUnderStatusBar {
      if #available(iOS 11.0, *) {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
      } else {
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height).isActive = true
      }
    } else {
      tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    let constraints = [
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
    constrainTableViewBottom(to: view.bottomAnchor)
  }

  private func setEpoxySectionsIfReady() {
    if traitCollection.horizontalSizeClass != .unspecified {
      updateData(animated: false)
    }
  }

}