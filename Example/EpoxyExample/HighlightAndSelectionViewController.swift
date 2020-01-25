// Created by Tyler Hedrick on 9/12/19.
// Copyright © 2019 Airbnb Inc. All rights reserved.

import Epoxy
import UIKit

class HighlightAndSelectionViewController: EpoxyTableViewController {
  // MARK: Initialization

  override init(epoxyLogger: EpoxyLogging = DefaultEpoxyLogger()) {
    super.init(epoxyLogger: epoxyLogger)

    self.tabBarItem = UITabBarItem.init(tabBarSystemItem: .history, tag: 1)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: EpoxyTableViewController

  override func epoxySections() -> [EpoxySection] {
    let items = (0..<10)
      .map { dataID -> EpoxyableModel in
        let text = kTestTexts[dataID]
        return BaseEpoxyModelBuilder<Row, String>(
          data: text,
          dataID: dataID)
          .configureView { context in
            context.view.titleText = "Row \(dataID)"
            context.view.text = text
          }
          .didSelect { context in
            print("DataID selected \(context.dataID) (selection handler)")
          }
          .build()
      }

    return [EpoxySection(items: items)]
  }
}
