// Created by eric_horacek on 3/17/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

/// All top-level examples available in this project.
enum Example: CaseIterable {
  case readme
  case product
  case compositionalLayout
  case cardStack
  case flowLayout
  case shuffle
  case customSelfSizing
  case textField
  case layoutGroups
  case swiftUIToEpoxy
  case epoxyToSwiftUI
  case swiftUIToEpoxyResizing

  // MARK: Internal

  var title: String {
    switch self {
    case .readme:
      return "Readme examples"
    case .customSelfSizing:
      return "Custom self-sizing cells"
    case .compositionalLayout:
      return "Compositional Layout"
    case .shuffle:
      return "Shuffle demo"
    case .product:
      return "Product Detail Page"
    case .flowLayout:
      return "Flow Layout demo"
    case .cardStack:
      return "Card Stack"
    case .textField:
      return "Text Field"
    case .layoutGroups:
      return "LayoutGroups"
    case .swiftUIToEpoxy:
      return "SwiftUI in Epoxy"
    case .epoxyToSwiftUI:
      return "Epoxy in SwiftUI"
    case .swiftUIToEpoxyResizing:
      return "SwiftUI in Epoxy, Resizing Cells"
    }
  }

  var body: String {
    switch self {
    case .readme:
      return "All of the examples from the README"
    case .customSelfSizing:
      return "A CollectionView with custom self-sizing cells"
    case .compositionalLayout:
      return "A CollectionView with a UICollectionViewCompositionalLayout"
    case .shuffle:
      return "A CollectionView with cells that are randomly shuffled on a timer"
    case .product:
      return "An example that combines collections, bars, and presentations"
    case .flowLayout:
      return "A CollectionView with a UICollectionViewFlowLayout"
    case .cardStack:
      return "A CollectionView with BarStackView items that have a card drawn around each stack"
    case .textField:
      return "An example that combines collections, bars, and text field with keyboard avoidance"
    case .layoutGroups:
      return "A set of examples written using EpoxyLayoutGroups"
    case .swiftUIToEpoxy:
      return "An example of SwiftUI views being embedded in Epoxy"
    case .epoxyToSwiftUI:
      return "An example of Epoxy views being embedded in SwiftUI"
    case .swiftUIToEpoxyResizing:
      return "An example of SwiftUI views being embedded in Epoxy that can invalidate their size"
    }
  }
}
