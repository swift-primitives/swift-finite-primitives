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
        /// - Parameter __unchecked: Marker parameter indicating unchecked access.
        /// - Parameter rawValue: Must be in 0..<N.
        @inlinable
        public init(__unchecked: Void, _ rawValue: Int) {
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
//     public static var zero: Self { Self(__unchecked: (), 0) }
//
//     /// The last inhabitant (index N - 1).
//     @inlinable
//     public static var max: Self { Self(__unchecked: (), N - 1) }
// }
//
// Until then, use the failable initializer: `Ordinal(0)` or `Ordinal(N - 1)`.

// MARK: - Successor

extension Finite.Ordinal {
    /// Accessor for successor operations.
    ///
    /// Use `ordinal.successor()` for the strict (failable) version,
    /// or `ordinal.successor.wrapping` for modular arithmetic (when available).
    public struct Successor: Sendable {
        @usableFromInline
        let ordinal: Finite.Ordinal<N>

        @usableFromInline
        init(_ ordinal: Finite.Ordinal<N>) {
            self.ordinal = ordinal
        }

        /// The next ordinal value, or `nil` if at maximum.
        ///
        /// - Returns: `Ordinal` with `rawValue + 1`, or `nil` if `rawValue == N - 1`.
        @inlinable
        public func callAsFunction() -> Finite.Ordinal<N>? {
            Finite.Ordinal<N>(ordinal.rawValue + 1)
        }
    }

    /// Accessor for successor operations.
    @inlinable
    public var successor: Successor { Successor(self) }
}

// MARK: - Predecessor

extension Finite.Ordinal {
    /// Accessor for predecessor operations.
    ///
    /// Use `ordinal.predecessor()` for the strict (failable) version,
    /// or `ordinal.predecessor.wrapping` for modular arithmetic (when available).
    public struct Predecessor: Sendable {
        @usableFromInline
        let ordinal: Finite.Ordinal<N>

        @usableFromInline
        init(_ ordinal: Finite.Ordinal<N>) {
            self.ordinal = ordinal
        }

        /// The previous ordinal value, or `nil` if at minimum.
        ///
        /// - Returns: `Ordinal` with `rawValue - 1`, or `nil` if `rawValue == 0`.
        @inlinable
        public func callAsFunction() -> Finite.Ordinal<N>? {
            Finite.Ordinal<N>(ordinal.rawValue - 1)
        }
    }

    /// Accessor for predecessor operations.
    @inlinable
    public var predecessor: Predecessor { Predecessor(self) }
}

// MARK: - Wrapping Operations (Awaiting Language Support)
//
// The following operations require value-generic constraints (`where N > 0`),
// which Swift does not yet support. Wrapping operations perform modular
// arithmetic and are only well-defined when N > 0.
//
// For `Ordinal<0>`, there are no inhabitants to wrap between.
//
// When Swift adds value-generic constraints, uncomment these extensions:
//
// extension Finite.Ordinal.Successor where N > 0 {
//     /// The next ordinal value, wrapping from max to zero.
//     ///
//     /// Performs modular increment: `(rawValue + 1) mod N`.
//     @inlinable
//     public var wrapping: Finite.Ordinal<N> {
//         Finite.Ordinal<N>(__unchecked: (), (ordinal.rawValue + 1) % N)
//     }
// }
//
// extension Finite.Ordinal.Predecessor where N > 0 {
//     /// The previous ordinal value, wrapping from zero to max.
//     ///
//     /// Performs modular decrement: `(rawValue - 1 + N) mod N`.
//     @inlinable
//     public var wrapping: Finite.Ordinal<N> {
//         Finite.Ordinal<N>(__unchecked: (), (ordinal.rawValue - 1 + N) % N)
//     }
// }
//
// Until then, use the failable `successor()`/`predecessor()` and handle nil.

// MARK: - Distance

extension Finite.Ordinal {
    /// The signed distance from this ordinal to another.
    ///
    /// - Returns: `other.rawValue - self.rawValue`
    @inlinable
    public func distance(to other: Self) -> Int {
        other.rawValue - rawValue
    }
}

// MARK: - Offset

extension Finite.Ordinal {
    /// Accessor for offset operations.
    ///
    /// Use `ordinal.offset(by:)` for strict (failable) offset,
    /// or `ordinal.offset.clamped(by:)` for bounds-clamped offset.
    public struct Offset: Sendable {
        @usableFromInline
        let ordinal: Finite.Ordinal<N>

        @usableFromInline
        init(_ ordinal: Finite.Ordinal<N>) {
            self.ordinal = ordinal
        }

        /// Returns an ordinal offset by the given signed amount, or `nil` if out of bounds.
        ///
        /// - Parameter delta: The signed offset to apply.
        /// - Returns: The offset ordinal, or `nil` if the result would be outside `0..<N`.
        @inlinable
        public func callAsFunction(by delta: Int) -> Finite.Ordinal<N>? {
            Finite.Ordinal<N>(ordinal.rawValue + delta)
        }

        /// Returns an ordinal offset by the given amount, clamped to valid bounds.
        ///
        /// - Parameter delta: The signed offset to apply.
        /// - Returns: The offset ordinal, clamped to `0` or `N-1` if out of bounds.
        @inlinable
        public func clamped(by delta: Int) -> Finite.Ordinal<N> {
            let result = ordinal.rawValue + delta
            if result < 0 { return Finite.Ordinal<N>(__unchecked: (), 0) }
            if result >= N { return Finite.Ordinal<N>(__unchecked: (), N - 1) }
            return Finite.Ordinal<N>(__unchecked: (), result)
        }
    }

    /// Accessor for offset operations.
    @inlinable
    public var offset: Offset { Offset(self) }
}

// MARK: - Complement (Awaiting Language Support)
//
// The complement operation requires value-generic constraints (`where N > 0`),
// which Swift does not yet support. The complement of ordinal i is (N - 1 - i),
// effectively mirroring the value across the midpoint.
//
// For `Ordinal<0>`, there are no inhabitants to complement.
//
// When Swift adds value-generic constraints, uncomment this extension:
//
// extension Finite.Ordinal where N > 0 {
//     /// The complement of this ordinal: `N - 1 - rawValue`.
//     ///
//     /// Maps 0 to max, 1 to max-1, etc. For `Ordinal<3>`:
//     /// - 0 → 2
//     /// - 1 → 1
//     /// - 2 → 0
//     @inlinable
//     public var complement: Self {
//         Self(__unchecked: (), N - 1 - rawValue)
//     }
// }
//
// Until then, compute manually: `Ordinal(__unchecked: (), N - 1 - ordinal.rawValue)`

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
        Finite.Ordinal<M>(__unchecked: (), rawValue)
    }

    /// Attempts to convert to an `Ordinal` of a smaller domain.
    ///
    /// - Returns: The converted ordinal, or `nil` if value is too large.
    @inlinable
    public func projected<let M: Int>() -> Finite.Ordinal<M>? {
        Finite.Ordinal<M>(rawValue)
    }
}

// MARK: - Product Isomorphism (Fin (m×n) ≅ Fin m × Fin n)

extension Finite.Ordinal {
    /// Decomposes this ordinal into row and column coordinates.
    ///
    /// Interprets `self` as a row-major index in a grid with `Columns` columns:
    /// - row = `rawValue / Columns`
    /// - column = `rawValue % Columns`
    ///
    /// This is the inverse of `init(row:column:)`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // 3×4 grid, index 7 → row 1, column 3
    /// let index: Finite.Ordinal<12> = Finite.Ordinal(7)!
    /// let (row, column): (Finite.Ordinal<3>, Finite.Ordinal<4>) = index.decomposed()!
    /// // row.rawValue == 1, column.rawValue == 3
    /// ```
    ///
    /// - Returns: `(row, column)`, or `nil` if `Rows × Columns ≠ N`.
    @inlinable
    public func decomposed<let Rows: Int, let Columns: Int>() -> (row: Finite.Ordinal<Rows>, column: Finite.Ordinal<Columns>)? {
        guard Rows * Columns == N else { return nil }
        let row = rawValue / Columns
        let column = rawValue % Columns
        return (Finite.Ordinal<Rows>(__unchecked: (), row), Finite.Ordinal<Columns>(__unchecked: (), column))
    }

    /// Creates an ordinal from row and column indices (row-major linear index).
    ///
    /// Computes the row-major linear index: `row × Columns + column` where `Columns` is
    /// the number of columns (the column ordinal's cardinality).
    ///
    /// This is the inverse of `decomposed()`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // 3×4 grid, row 1, column 3 → index 7
    /// let row: Finite.Ordinal<3> = Finite.Ordinal(1)!
    /// let column: Finite.Ordinal<4> = Finite.Ordinal(3)!
    /// let index: Finite.Ordinal<12> = .init(row: row, column: column)!
    /// // index.rawValue == 7
    /// ```
    ///
    /// - Returns: The combined ordinal, or `nil` if `Rows × Columns ≠ N`.
    @inlinable
    public init?<let Rows: Int, let Columns: Int>(
        row: Finite.Ordinal<Rows>,
        column: Finite.Ordinal<Columns>
    ) {
        guard Rows * Columns == N else { return nil }
        self.init(__unchecked: (), row.rawValue * Columns + column.rawValue)
    }
}

// MARK: - Sum Isomorphism (Awaiting Either Type)
//
// The sum isomorphism `Fin (m + n) ≅ Fin m + Fin n` requires a sum type
// (Either/Result) to express. This decomposes an ordinal at a boundary K
// into "left" values (0..<K) or "right" values (K..<N).
//
// When an Either type is available, uncomment this extension:
//
// extension Finite.Ordinal {
//     /// Splits this ordinal at boundary K into left or right component.
//     ///
//     /// Values 0..<K become `.left(Ordinal<K>)`.
//     /// Values K..<N become `.right(Ordinal<M>)` where K + M = N.
//     ///
//     /// - Returns: `.left` or `.right`, or `nil` if `K + M ≠ N`.
//     @inlinable
//     public func split<let K: Int, let M: Int>() -> Either<Ordinal<K>, Ordinal<M>>? {
//         guard K + M == N else { return nil }
//         if rawValue < K {
//             return .left(Ordinal<K>(__unchecked: (), rawValue))
//         } else {
//             return .right(Ordinal<M>(__unchecked: (), rawValue - K))
//         }
//     }
//
//     /// Creates an ordinal from either a left or right component.
//     ///
//     /// `.left` values map to 0..<K.
//     /// `.right` values map to K..<N.
//     ///
//     /// - Returns: The joined ordinal, or `nil` if `K + M ≠ N`.
//     @inlinable
//     public init?<let K: Int, let M: Int>(
//         _ value: Either<Ordinal<K>, Ordinal<M>>
//     ) {
//         guard K + M == N else { return nil }
//         switch value {
//         case .left(let ordinal): self.init(__unchecked: (), ordinal.rawValue)
//         case .right(let ordinal): self.init(__unchecked: (), K + ordinal.rawValue)
//         }
//     }
// }
//
// Until then, use rawValue arithmetic directly.

// MARK: - Finite.Enumerable

extension Finite.Ordinal: Finite.Enumerable {
    /// Number of values in `Ordinal<N>`.
    @inlinable
    public static var caseCount: Int { N }

    /// Index of this value.
    @inlinable
    public var caseIndex: Int { rawValue }

    // `init(__unchecked:_:)` requirement satisfied by struct's init.
}

// MARK: - Array Subscripting

extension Array {
    /// Accesses an element at a type-safe ordinal index.
    @inlinable
    public subscript<let N: Int>(index: Finite.Ordinal<N>) -> Element {
        self[index.rawValue]
    }
}
