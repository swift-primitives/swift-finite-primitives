// Finite.Enumerable.swift
// Protocol for types with finitely many indexed inhabitants.

import Ordinal_Primitives

extension Finite {
    /// A finite type with indexed, enumerable values.
    ///
    /// `Enumerable` types have exactly `count` distinct values, each with
    /// a unique ordinal in 0..<count. Conforming types automatically gain
    /// `CaseIterable` with a zero-allocation `RandomAccessCollection`.
    ///
    /// Any `Enumerable` type with N values is isomorphic to `Ordinal<N>`:
    /// `init(__unchecked:ordinal:)` maps from `Ordinal<N>` to `Self`, while
    /// `ordinal` provides the inverse.
    ///
    /// ## Checked vs Unchecked Access
    ///
    /// - `init(__unchecked:ordinal:)`: Fast, unchecked. Only valid for `0..<count`.
    /// - `init?(_:)`: Total, safe. Returns `nil` for invalid ordinals.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct CardSuit: Finite.Enumerable {
    ///     static let count = 4
    ///     let ordinal: Int
    ///     init(__unchecked: Void, ordinal: Int) { self.ordinal = ordinal }
    ///
    ///     static let hearts = CardSuit(__unchecked: (), ordinal: 0)
    ///     // ... define other suits
    /// }
    ///
    /// for suit in CardSuit.allCases { ... }  // Automatic iteration
    /// ```
    public protocol Enumerable: CaseIterable, Sendable {
        /// Number of distinct values of this type.
        static var count: Cardinal { get }

        /// Ordinal position of this value (0 to count-1).
        var ordinal: Ordinal_Primitives.Ordinal { get }

        /// Creates a value from its ordinal without bounds checking.
        ///
        /// This is the unchecked fast path. For safe access with untrusted input,
        /// use `init?(_:)` instead.
        ///
        /// - Parameter __unchecked: Marker parameter indicating unchecked access.
        /// - Parameter ordinal: Must be in `0..<count`.
        init(__unchecked: Void, ordinal: Ordinal_Primitives.Ordinal)
    }
}

// MARK: - Default CaseIterable Implementation

extension Finite.Enumerable {
    /// All values of this type (zero-allocation sequence).
    @inlinable
    public static var allCases: Finite.Enumeration<Self> {
        Finite.Enumeration()
    }
}

// MARK: - Total Initializer

extension Finite.Enumerable {
    /// Creates a value from its ordinal, if within bounds.
    ///
    /// This is the total, safe initializer. For trusted ordinals where bounds
    /// are already guaranteed, use `init(__unchecked:ordinal:)` for performance.
    ///
    /// - Parameter ordinal: The ordinal position.
    /// - Returns: The value at that ordinal, or `nil` if out of bounds.
    @inlinable
    public init?(_ ordinal: Ordinal) {
        guard ordinal < Self.count else { return nil }  // Ordinal is always >= 0
        self.init(__unchecked: (), ordinal: ordinal)
    }
}
