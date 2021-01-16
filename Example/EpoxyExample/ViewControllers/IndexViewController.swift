// Created by Tyler Hedrick on 1/12/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import Epoxy
import Foundation
import UIKit

final class IndexViewController: EpoxyCollectionViewController {

  init(didSelectItem: @escaping (ListItem) -> Void) {
    self.didSelectItem = didSelectItem
    super.init(collectionViewLayout: UICollectionViewCompositionalLayout.list)
    title = "Epoxy"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  enum ListItem: CaseIterable {
    case highlightAndSelection
    case shuffle
    case customSelfSizing
    case product
  }

  override func epoxySections() -> [SectionModel] {
    [
      SectionModel(items: items())
    ]
  }

  // MARK: Private

  private let didSelectItem: (ListItem) -> Void

  private func items() -> [ItemModeling] {
    ListItem.allCases.map { item in
      Row.itemModel(dataID: item, content: .init(title: item.rowTitle), style: .small)
        .didSelect { [weak self] _ in
          self?.didSelectItem(item)
        }
    }
  }
  
}

extension IndexViewController.ListItem {
  var rowTitle: String {
    switch self {
    case .customSelfSizing:
      return "Custom self-sizing cells"
    case .highlightAndSelection:
      return "Highlight and selection demo"
    case .shuffle:
      return "Shuffle demo"
    case .product:
      return "Product Detail Page"
    }
  }
}
