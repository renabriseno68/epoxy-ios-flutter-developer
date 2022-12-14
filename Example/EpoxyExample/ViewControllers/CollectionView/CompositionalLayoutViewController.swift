// Created by Tyler Hedrick on 9/12/19.
// Copyright © 2019 Airbnb Inc. All rights reserved.

import Epoxy
import UIKit

final class CompositionalLayoutViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    setSections(sections, animated: false)
  }

  // MARK: Private

  private enum SectionID {
    case carousel, list
  }

  @SectionModelBuilder private var sections: [SectionModel] {
    SectionModel(dataID: SectionID.carousel) {
      (0..<10).map { (dataID: Int) in
        TextRow.itemModel(
          dataID: dataID,
          content: .init(title: "Page \(dataID)"),
          style: .small)
          .didSelect { _ in
            // swiftlint:disable:next no_direct_standard_out_logs
            print("Carousel page \(dataID) did select")
          }
          .willDisplay { _ in
            // swiftlint:disable:next no_direct_standard_out_logs
            print("Carousel page \(dataID) will display")
          }
      }
    }
    .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
      TextRow.supplementaryItemModel(dataID: 0, content: .init(title: "Carousel section"), style: .large),
    ])
    .compositionalLayoutSection(.carouselWithHeader)

    SectionModel(dataID: SectionID.list) {
      (0..<10).map { (dataID: Int) in
        TextRow.itemModel(
          dataID: dataID,
          content: .init(title: "Row \(dataID)", body: BeloIpsum.paragraph(count: 1, seed: dataID)),
          style: .small)
          .didSelect { _ in
            // swiftlint:disable:next no_direct_standard_out_logs
            print("List row \(dataID) selected")
          }
          .willDisplay { _ in
            // swiftlint:disable:next no_direct_standard_out_logs
            print("List row \(dataID) will display")
          }
      }
    }
    .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
      TextRow.supplementaryItemModel(dataID: 0, content: .init(title: "List section"), style: .large),
    ])
    .compositionalLayoutSectionProvider(NSCollectionLayoutSection.listWithHeader)
  }
}
