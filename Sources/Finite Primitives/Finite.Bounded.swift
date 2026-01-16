// Finite.Bounded.swift
// Protocol for finite types with minimum and maximum bounds.

// MARK: - Bounded Protocol (Awaiting Language Support)
//
// The following protocol requires value-generic constraints (`where N > 0`),
// which Swift does not yet support. `Bounded` defines types with known minimum
// and maximum values—a concept from Haskell's `Bounded` typeclass.
//
// ## Why a Protocol, Not a Struct Witness?
//
// For finite types, bounds are intrinsic—not configurable. `Ordinal<5>` always
// has bounds 0..4; there's exactly one valid bounds instance. A struct witness
// like `Bounds<T>` would add ceremony without benefit:
//
//     // Struct witness (unnecessary ceremony):
//     Finite.Bounds(for: Ordinal<5>.self).min
//
//     // Protocol (natural Swift idiom):
//     Ordinal<5>.minBound
//
// Protocols also compose naturally with other capabilities: a type can be both
// `Enumerable` and `Bounded`, and the default implementation derives bounds
// from enumeration indices.
//
// For finite types like `Ordinal<N>`, bounds are only meaningful when N > 0:
// - `Ordinal<0>` has no inhabitants, so no min/max exists
// - `Ordinal<1>` has one inhabitant: min = max = 0
// - `Ordinal<N>` for N > 1 has min = 0, max = N - 1
//
// Rather than:
// - Use `precondition` (runtime policy, violates primitives philosophy)
// - Return `Optional` (changes semantics, caller burden for known-safe cases)
// - Omit the protocol entirely (loses valuable type-level documentation)
//
// We provide the protocol definition commented out, anticipating Swift's
// future support for value-generic constraints.
//
// When Swift adds value-generic constraints, uncomment this code:
//
// extension Finite {
//     /// A type with known minimum and maximum bounds.
//     ///
//     /// `Bounded` types have a smallest and largest value. Combined with
//     /// `Enumerable`, this enables safe iteration and boundary operations.
//     ///
//     /// ## Relationship to Enumerable
//     ///
//     /// For `Enumerable` types:
//     /// - `minBound` corresponds to `caseIndex == 0`
//     /// - `maxBound` corresponds to `caseIndex == caseCount - 1`
//     ///
//     /// ## Example
//     ///
//     /// ```swift
//     /// extension CardSuit: Finite.Bounded {
//     ///     static var minBound: Self { .hearts }
//     ///     static var maxBound: Self { .spades }
//     /// }
//     ///
//     /// let first = CardSuit.minBound  // .hearts
//     /// let last = CardSuit.maxBound   // .spades
//     /// ```
//     public protocol Bounded: Sendable {
//         /// The minimum value of this type.
//         static var minBound: Self { get }
//
//         /// The maximum value of this type.
//         static var maxBound: Self { get }
//     }
// }
//
// // MARK: - Ordinal: Bounded
//
// extension Finite.Ordinal: Finite.Bounded where N > 0 {
//     /// The minimum ordinal value (index 0).
//     @inlinable
//     public static var minBound: Self { Self(unchecked: 0) }
//
//     /// The maximum ordinal value (index N - 1).
//     @inlinable
//     public static var maxBound: Self { Self(unchecked: N - 1) }
// }
//
// // MARK: - Default Implementation for Enumerable
//
// extension Finite.Bounded where Self: Finite.Enumerable {
//     /// Default minimum bound: the value at case index 0.
//     @inlinable
//     public static var minBound: Self { Self(caseIndex: 0) }
//
//     /// Default maximum bound: the value at case index (caseCount - 1).
//     @inlinable
//     public static var maxBound: Self { Self(caseIndex: caseCount - 1) }
// }
//
// Until Swift supports value-generic constraints, use explicit initialization:
// - `Ordinal(0)` for minimum (returns nil for Ordinal<0>)
// - `Ordinal(N - 1)` for maximum (returns nil for Ordinal<0>)
// - For Enumerable types: `T(caseIndex: 0)` and `T(caseIndex: T.caseCount - 1)`
