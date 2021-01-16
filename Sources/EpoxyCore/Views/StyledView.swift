//  Created by Laura Skelton on 4/14/16.
//  Copyright © 2016 Airbnb. All rights reserved.

import UIKit

// MARK: - StyledView

/// A view that can be initialized with a `Style` instance that contains the view's invariant
/// configuration parameters, e.g. the `UIButton.ButtonType` of a `UIButton`.
///
/// A `Style` is expected to be invariant over the lifecycle of the view; it should not possible to
/// change the `Style` of a view after it is created. All variant properties of the view should
/// either be included in the `ContentConfigurableView.Content` if they are `Equatable` (e.g. a
/// title `String`) or the `BehaviorsConfigurableView.Behaviors` if they are not (e.g. a callback
/// closure).
///
/// A `Style` is `Hashable` to allow views of the same type with equal `Style`s to be reused by
/// establishing whether their invariant `Style` instances are equal.
///
/// Properties of `Style` should mutually exclusive with the properties of the
/// `ContentConfigurableView.Content` and `BehaviorsConfigurableView.Behaviors`.
///
/// - SeeAlso: `ContentConfigurableView`
/// - SeeAlso: `BehaviorsConfigurableView`
/// - SeeAlso: `EpoxyableView`
public protocol StyledView: UIView {
  /// The style type of this view, passed into its initializer to configure the resulting instance.
  ///
  /// Defaults to `EmptyStyle` for views that do not have a `Style`.
  associatedtype Style: Hashable = EmptyStyle

  /// Creates an instance of this view configured with the given `Style` instance.
  init(style: Style)
}

// MARK: Extensions

extension StyledView where Style == EmptyStyle {
  public init(style: Style) {
    // If you're getting a `EXC_BAD_INSTRUCTION` crash with this method in your stack trace, you
    // probably conformed a view to `EpoxyableView` / `StyledView` with a custom initializer that
    // takes parameters. If you have parameters to view initialization, they should either be passed
    // to `init(style:)` or you should provide a `makeView` closure when constructing your view's
    // corresponding Epoxy model, e.g:
    // ```
    // MyView.itemModel(…)
    //   .makeView { MyView(customParameter: …) }
    //   .alternateStyleID(…)
    // ```
    // Note that with the above approach that you must supply an `alternateStyleID` with the same
    // identity as your view parameters to ensure that views with different parameters are not
    // reused in place of one another.
    self.init()
  }
}

// MARK: - EmptyStyle

/// A type used to allow a view with no style to conform to `StyledView`.
///
/// The default `Style` for `StyledView`s that do not have a custom associated `Style` type.
public struct EmptyStyle: Hashable {
  /// The single shared instance of `EmptyStyle`.
  public static let shared = EmptyStyle()
}
