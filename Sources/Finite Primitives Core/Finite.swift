// Finite.swift
// Namespace for finite type infrastructure.

/// Namespace for finite type infrastructure.
///
/// `Finite` contains types for working with finite sets—types that have
/// a known, countable number of inhabitants that can be indexed.
///
/// ## Core Types
///
/// - ``Bound``: Phantom tag indicating boundedness to N values
/// - ``Enumerable``: Protocol for types with finitely many indexed inhabitants
/// - ``Enumeration``: Zero-allocation collection over enumerable types
///
/// ## Bounded Ordinals
///
/// Use `Ordinal.Finite<N>` for bounded ordinal positions:
///
/// ```swift
/// var idx: Ordinal.Finite<4> = .zero
/// idx = idx.successor()!  // 1
/// idx = idx.successor()!  // 2
/// idx = idx.successor()!  // 3
/// idx.successor()         // nil (at bound)
/// ```
///
/// ## Enumerable Types
///
/// ```swift
/// struct CardSuit: Finite.Enumerable {
///     static let count: Cardinal = 4
///     let ordinal: Ordinal
///     init(__unchecked: Void, ordinal: Ordinal) { self.ordinal = ordinal }
/// }
///
/// for suit in CardSuit.allCases { ... }
/// ```
public enum Finite: Sendable {}

// MARK: - Finite.Bound

extension Finite {
    /// Phantom tag indicating a value is bounded to the range [0, N).
    ///
    /// `Bound<N>` is used as a tag in `Tagged<Finite.Bound<N>, RawValue>` to indicate
    /// that the wrapped value is constrained to N possible values.
    ///
    /// ## Usage
    ///
    /// Typically used via the `Ordinal.Finite<N>` typealias:
    ///
    /// ```swift
    /// // Ordinal.Finite<4> = Tagged<Finite.Bound<4>, Ordinal>
    /// let idx: Ordinal.Finite<4> = .zero
    /// idx.successor()  // Returns nil at boundary
    /// ```
    ///
    /// The bound N is accessible via `Ordinal.Finite<N>.capacity()`.
    public struct Bound<let N: Int>: Hashable, Sendable {
        /// Creates a bound marker.
        @inlinable
        public init() {}
    }
}
