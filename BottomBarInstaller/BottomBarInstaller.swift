// Created by eric_horacek on 8/20/19.
// Copyright © 2019 Airbnb Inc. All rights reserved.

import ConstellationCoreUI
import UIKit

/// Installs a stack of bar views into a view controller.
///
/// The bar stack is constrained to the bottom of the view controller's view.
///
/// The view controller's safe area inset bottom is automatically inset by the height of the bar
/// stack, ensuring that any scrollable content is inset by the height of the bar.
public final class BottomBarInstaller: NSObject {

  // MARK: Lifecycle

  public init(viewController: UIViewController, avoidsKeyboard: Bool = false) {
    self.viewController = viewController
    keyboardPositionWatcher.enabled = avoidsKeyboard
  }

  // MARK: Public

  /// The container installed in the view controller's view that contains the bar stack.
  ///
  /// Non-`nil` while installed, `nil` otherwise.
  public var container: BottomBarContainer? { installer.container }

  /// Updates the bar to the given bar model.
  ///
  /// If the model correponds to the same view as was previously set, the view will be reused and
  /// updated with the new content, optionally animated.
  ///
  /// If the model corresponds to a new view, the bar view will be replaced, optionally animated.
  ///
  /// If the model is `nil`, the bar will be removed, if there was one.
  public func setModel(_ model: BarModeling?, animated: Bool) {
    installer.setModels([model].compactMap { $0 }, animated: animated)
  }

  /// Updates the bar stack to the given bar models, ordered from top to bottom.
  ///
  /// If any model correponds to the same view as was previously set, the view will be reused and
  /// updated with the new content, optionally animated.
  ///
  /// If any model corresponds to a new view, a new view will be created and inserted, optionally
  /// animated.
  ///
  /// If any model is no longer present, its corresponding view will be removed.
  public func setModels(_ models: [BarModeling], animated: Bool) {
    installer.setModels(models, animated: animated)
  }

  /// Installs the bar stack into its associated view controller.
  ///
  /// Should be called once the view controller loads its view. If this installer has no bar models,
  /// no view will be added. A view will only be added once a non-`nil` bar model is set after
  /// installation or if a bar model was set prior to installation.
  public func install() {
    installer.install()
    watchKeyboardPosition(true)
  }

  /// Removes the bar stack from its associated view controller.
  public func uninstall() {
    installer.uninstall()
    watchKeyboardPosition(false)
  }

  // MARK: Private

  /// The view controller that will have its `additionalSafeAreaInsets` updated to accommodate for
  /// the bar view.
  private weak var viewController: UIViewController?

  private let keyboardPositionWatcher = KeyboardPositionWatcher()
  private var keyboardPosition: CGFloat? = nil

  private lazy var installer = BarInstaller<BottomBarContainer>(
    viewController: viewController,
    willDisplayBar: { bar in
      (bar as? LegacyBottomBarView)?.prepareForInstallation()
    })

  /// The distance that the keyboard overlaps with `viewController.view` from its bottom edge.
  var keyboardOverlap: CGFloat = 0 {
    didSet {
      guard keyboardOverlap != oldValue else { return }
      container?.bottomOffset = keyboardOverlap
    }
  }

  private func watchKeyboardPosition(_ enable: Bool) {
    guard keyboardPositionWatcher.enabled else { return }

    guard let view = viewController?.viewIfLoaded else {
      assertionFailure("Should only watch keyboard for a view controller that's loaded its view")
      return
    }

    if enable {
      keyboardPositionWatcher.observeOverlap(in: view) { [weak self] overlap in
        self?.keyboardOverlap = overlap
      }
    } else {
      keyboardPositionWatcher.stopObserving(in: view)
    }
  }

}

// MARK: BarCoordinatorPropertyConfigurable

extension BottomBarInstaller: BarCoordinatorPropertyConfigurable {
  public subscript<Property>(property: BarCoordinatorProperty<Property>) -> Property {
    get { installer[property] }
    set { installer[property] = newValue }
  }
}

// MARK: - LegacyBottomBarView

/// Describes a bottom bar view that constrains its content using `constrainToBottomSafeArea(of:)`,
/// which doesn't interoperate gracefully with `BottomBarContainer`, since it covers the entire
/// bar with a safe area.
public protocol LegacyBottomBarView {
  /// The constraints that are added via the legacy `constrainToBottomSafeArea(of:)`.
  var bottomSafeAreaConstraints: [NSLayoutConstraint] { get }
  /// The constraints that are constrained via standard UIKit bottom margins.
  var bottomMarginConstraints: [NSLayoutConstraint] { get }
}

private extension LegacyBottomBarView {
  func prepareForInstallation() {
    NSLayoutConstraint.deactivate(bottomSafeAreaConstraints)
    NSLayoutConstraint.activate(bottomMarginConstraints)
  }
}
