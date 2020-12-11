// Created by eric_horacek on 12/1/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

// MARK: - DataIDProviding

/// The capability of providing a stable data identifier with an erased type.
///
/// While it has similar semantics, this type cannot inherit from `Identifiable` as this would give
/// it an associated type, which would cause the `keyPath` used in its `EpoxyModelProperty` to not
/// be stable across types if written as `\Self.dataID` since the `KeyPath` `Root` would be
/// different for each type.
///
/// - SeeAlso: `Identifiable`.
public protocol DataIDProviding {
  /// A stable identifier that uniquely identifies this instance, with its typed erased.
  var dataID: AnyHashable { get }
}

// MARK: - EpoxyModeled

extension EpoxyModeled where Self: DataIDProviding {

  // MARK: Public

  /// A stable identifier that uniquely identifies this model, with its typed erased.
  public var dataID: AnyHashable {
    get { self[dataIDProperty] }
    set { self[dataIDProperty] = newValue }
  }

  /// Returns a copy of this model with the ID replaced with the provided ID.
  public func dataID(_ value: AnyHashable) -> Self {
    copy(updating: dataIDProperty, to: value)
  }

  // MARK: Private

  private var dataIDProperty: EpoxyModelProperty<AnyHashable> {
    EpoxyModelProperty(
      keyPath: \DataIDProviding.dataID,
      defaultValue: {
        EpoxyLogger.shared.assertionFailure("dataID must be set at init, this is programmer error")
        return ""
      }(),
      updateStrategy: .replace)
  }
}
