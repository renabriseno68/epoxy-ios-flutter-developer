// Created by Cal Stephens on 11/30/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

import Nimble
import Quick
import UIKit

@testable import EpoxyBars

final class BottomBarInstallerSpec: QuickSpec, BaseBarInstallerSpec {

  func installBarContainer(
    in viewController: UIViewController,
    configuration: BarInstallerConfiguration)
    -> (container: InternalBarContainer, setBars: ([BarModeling], Bool) -> Void)
  {
    let barInstaller = BottomBarInstaller(viewController: viewController, configuration: configuration)
    viewController.view.layoutIfNeeded()
    barInstaller.install()

    return (
      container: barInstaller.container!,
      setBars: { barInstaller.setBars($0, animated: $1) })
  }

  override func spec() {
    baseSpec()

    describe("BottomBarContainer") {
      it("has a reference to the BottomBarInstaller when installed") {
        let viewController = UIViewController()
        viewController.loadView()
        let barInstaller = BottomBarInstaller(viewController: viewController)

        barInstaller.install()
        expect(barInstaller.container?.barInstaller).toEventually(equal(barInstaller))

        barInstaller.uninstall()
        expect(barInstaller.container?.barInstaller).toEventually(beNil())
      }
    }
  }

}
