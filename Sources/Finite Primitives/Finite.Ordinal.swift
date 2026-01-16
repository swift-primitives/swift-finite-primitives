// Finite.Ordinal.swift
// The canonical finite type with exactly N inhabitants.

extension Finite {
    /// A value in the finite set {0, 1, ..., N-1}.
    ///
    /// `Ordinal<N>` is the canonical type with exactly N distinct values,
    /// indexed 0 through N-1. It represents the von Neumann ordinal (set theory)
    /// or `Fin n` (type theory).
    ///
    /// Use it as a type-safe array index, to represent any N-valued enumeration,
    /// or as the foundation for finite types. Many types are isomorphic to
    /// `Ordinal<N>`: `Bool ≅ Ordinal<2>`, `Axis<N> ≅ Ordinal<N>`, etc.
    ///
    /// - Note: N must be greater than 0 for most operations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let index: Finite.Ordinal<3> = Finite.Ordinal(1)!
    /// let values = [10, 20, 30]
    /// print(values[index])  // 20
    ///
    /// // Iterate all values
    /// for i in Finite.Ordinal<4>.allCases { print(i.rawValue) }  // 0, 1, 2, 3
    /// ```
    public struct Ordinal<let N: Int>: Sendable, Hashable {
        /// Underlying integer value (0 to N-1).
        public let rawValue: Int

        /// Creates an ordinal from an integer, if within bounds.
        ///
        /// - Returns: The ordinal, or `nil` if out of bounds.
        @inlinable
        public init?(_ rawValue: Int) {
            guard rawValue >= 0 && rawValue < N else { return nil }
            self.rawValue = rawValue
        }

        /// Creates an ordinal without bounds checking.
        ///
        /// - Precondition: `rawValue` must be in 0..<N
        @inlinable
        public init(unchecked rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Type Alias

extension Finite {
    /// Type alias for `Ordinal` using the traditional type-theoretic name `Fin n`.
    ///
    /// Use `Finite.Ordinal<N>` in most code; `Finite.Fin<N>` is provided for
    /// users familiar with the type-theoretic convention.
    public typealias Fin<let N: Int> = Ordinal<N>
}

// MARK: - Count

extension Finite.Ordinal {
    /// Number of inhabitants of this type.
    @inlinable
    public static var count: Int { N }
}

// MARK: - Inhabitant Conveniences (Awaiting Language Support)
//
// The following extension requires value-generic constraints (`where N > 0`),
// which Swift does not yet support. These APIs are only total for N > 0:
//
// - `zero` returns the first inhabitant (index 0)
// - `max` returns the last inhabitant (index N - 1)
//
// For `Ordinal<0>`, the type has no inhabitants, so these would be unsound.
// Rather than:
// - Use `precondition` (runtime policy, violates primitives philosophy)
// - Return `Optional` (changes semantics, caller burden for known-safe cases)
// - Document as "undefined behavior" (implicit contract, error-prone)
//
// We choose to not provide the API until Swift can express the constraint.
// This keeps the API surface honest and anticipates the correct solution.
//
// When Swift adds value-generic constraints, uncomment this extension:
//
// extension Finite.Ordinal where N > 0 {
//     /// The first inhabitant (index 0).
//     @inlinable
//     public static var zero: Self { Self(unchecked: 0) }
//
//     /// The last inhabitant (index N - 1).
//     @inlinable
//     public static var max: Self { Self(unchecked: N - 1) }
// }
//
// Until then, use the failable initializer: `Ordinal(0)` or `Ordinal(N - 1)`.

// MARK: - Comparable

extension Finite.Ordinal: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Codable

#if !hasFeature(Embedded)
extension Finite.Ordinal: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Int.self)
        guard let ordinal = Self(value) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription:
                        "Value \(value) out of bounds for Finite.Ordinal<\(N)> (expected 0..<\(N))"
                )
            )
        }
        self = ordinal
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
#endif

// MARK: - Conversion

extension Finite.Ordinal {
    /// Converts to an `Ordinal` of a larger domain (safe upcast).
    ///
    /// - Precondition: N ≤ M
    @inlinable
    public func injected<let M: Int>() -> Finite.Ordinal<M> {
        Finite.Ordinal<M>(unchecked: rawValue)
    }

    /// Attempts to convert to an `Ordinal` of a smaller domain.
    ///
    /// - Returns: The converted ordinal, or `nil` if value is too large.
    @inlinable
    public func projected<let M: Int>() -> Finite.Ordinal<M>? {
        Finite.Ordinal<M>(rawValue)
    }
}

// MARK: - Finite.Enumerable

extension Finite.Ordinal: Finite.Enumerable {
    /// Number of values in `Ordinal<N>`.
    @inlinable
    public static var caseCount: Int { N }

    /// Index of this value.
    @inlinable
    public var caseIndex: Int { rawValue }

    /// Creates a value from its index.
    ///
    /// - Precondition: `caseIndex` must be in 0..<N
    @inlinable
    public init(caseIndex: Int) {
        self.init(unchecked: caseIndex)
    }
}

// MARK: - Array Subscripting

extension Array {
    /// Accesses an element at a type-safe ordinal index.
    @inlinable
    public subscript<let N: Int>(index: Finite.Ordinal<N>) -> Element {
        self[index.rawValue]
    }
}
