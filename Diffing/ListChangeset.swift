//  Created by Laura Skelton on 5/11/17.
//  Copyright © 2017 Airbnb. All rights reserved.

import Foundation

/// A set of the minimum changes to get from one array of `ListSection`s to another, used for diffing.
public struct ListChangeset {

  public init(
    sectionChangeset: IndexSetChangeset,
    itemChangeset: IndexPathChangeset)
  {
    self.sectionChangeset = sectionChangeset
    self.itemChangeset = itemChangeset
  }

  /// A set of the minimum changes to get from one set of sections to another.
  public let sectionChangeset: IndexSetChangeset

  /// A set of the minimum changes to get from one set of items to another, aggregated across all sections.
  public let itemChangeset: IndexPathChangeset
}
