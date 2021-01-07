// Created by eric_horacek on 12/1/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

// MARK: - AlternateStyleIDProviding

public protocol AlternateStyleIDProviding {
  /// An optional ID for an alternative style type to use for reuse of a view.
  ///
  /// Use this to differentiate between different styling configurations.
  var alternateStyleID: AnyHashable? { get }
}

// MARK: - EpoxyModeled

extension EpoxyModeled where Self: AlternateStyleIDProviding {

  // MARK: Public

  public var alternateStyleID: AnyHashable? {
    get { self[alternateStyleIDProperty] }
    set { self[alternateStyleIDProperty] = newValue }
  }

  /// Returns a copy of this model with the `alternateStyleID` replaced with the provided `value`.
  public func alternateStyleID(_ value: AnyHashable?) -> Self {
    copy(updating: alternateStyleIDProperty, to: value)
  }

  // MARK: Private

  private var alternateStyleIDProperty: EpoxyModelProperty<AnyHashable?> {
    .init(
      keyPath: \AlternateStyleIDProviding.alternateStyleID,
      defaultValue: nil,
      updateStrategy: .replace)
  }
}
