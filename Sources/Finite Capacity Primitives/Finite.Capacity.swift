// Finite.Capacity.swift
// Protocol for tags that carry a compile-time capacity.

import Cardinal_Primitives
public import Finite_Primitive

extension Finite {
    /// A tag type that declares a finite capacity.
    ///
    /// Types conforming to `Capacity` carry a static integer representing
    /// the number of valid values. This enables generic conditional
    /// conformances on `Tagged` for bounded ordinals.
    public protocol Capacity: Sendable {
        /// The number of valid values.
        static var capacity: Cardinal { get }
    }
}

// MARK: - Finite.Bound: Finite.Capacity

extension Finite.Bound: Finite.Capacity {
    /// The capacity is the bound N.
    @inlinable
    public static var capacity: Cardinal { Cardinal(UInt(N)) }
}
