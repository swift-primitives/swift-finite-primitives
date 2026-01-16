// Finite.Enumerable.swift
// Protocol for types with finitely many indexed inhabitants.

extension Finite {
    /// A finite type with indexed, enumerable values.
    ///
    /// `Enumerable` types have exactly `caseCount` distinct values, each with
    /// a unique index in 0..<caseCount. Conforming types automatically gain
    /// `CaseIterable` with a zero-allocation `RandomAccessCollection`.
    ///
    /// Any `Enumerable` type with N cases is isomorphic to `Ordinal<N>`:
    /// `init(__unchecked:_:)` maps from `Ordinal<N>` to `Self`, while
    /// `caseIndex` provides the inverse.
    ///
    /// ## Checked vs Unchecked Access
    ///
    /// - `init(__unchecked:_:)`: Fast, unchecked. Only valid for `0..<caseCount`.
    /// - `init?(validating:)`: Total, safe. Returns `nil` for invalid indices.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct CardSuit: Finite.Enumerable {
    ///     static let caseCount = 4
    ///     let caseIndex: Int
    ///     init(__unchecked: Void, _ index: Int) { self.caseIndex = index }
    ///
    ///     static let hearts = CardSuit(__unchecked: (), 0)
    ///     // ... define other suits
    /// }
    ///
    /// for suit in CardSuit.allCases { ... }  // Automatic iteration
    /// ```
    public protocol Enumerable: CaseIterable, Sendable {
        /// Number of distinct values of this type.
        static var caseCount: Int { get }

        /// Index of this value (0 to caseCount-1).
        var caseIndex: Int { get }

        /// Creates a value from its index without bounds checking.
        ///
        /// This is the unchecked fast path. For safe access with untrusted input,
        /// use `init?(validating:)` instead.
        ///
        /// - Parameter __unchecked: Marker parameter indicating unchecked access.
        /// - Parameter index: Must be in `0..<caseCount`.
        init(__unchecked: Void, _ index: Int)
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
    /// Creates a value from its index, if within bounds.
    ///
    /// This is the total, safe initializer. For trusted indices where bounds
    /// are already guaranteed, use `init(__unchecked:_:)` for performance.
    ///
    /// - Parameter index: The case index.
    /// - Returns: The value at that index, or `nil` if out of bounds.
    @inlinable
    public init?(_ index: Int) {
        guard index >= 0 && index < Self.caseCount else { return nil }
        self.init(__unchecked: (), index)
    }
}
