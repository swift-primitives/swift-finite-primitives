// Tagged+Ordinal.Finite.swift
// Bounded ordinal extensions on Tagged.

import Ordinal_Primitives
import Identity_Primitives

// MARK: - Construction

extension Tagged where Tag: ~Copyable {
    /// Creates a bounded ordinal from a position, returning nil if out of bounds.
    @inlinable
    public init?<let N: Int>(_ position: Ordinal)
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        guard position < Finite.Bound<N>.capacity else { return nil }
        self.init(__unchecked: (), position)
    }

    /// Creates a bounded ordinal from an integer, returning nil if out of bounds.
    @inlinable
    public init?<let N: Int>(_ value: Int)
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        guard value >= 0, value < N else { return nil }
        self.init(__unchecked: value)
    }

    /// Creates a bounded ordinal without bounds checking.
    ///
    /// - Parameter value: Must be in `0..<N`.
    /// - Warning: No validation is performed. Use only when the value
    ///   is known to be in bounds.
    @inlinable
    public init<let N: Int>(__unchecked value: Int)
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        self.init(__unchecked: (), Ordinal(UInt(value)))
    }
}

// MARK: - Bounds

extension Tagged where Tag: ~Copyable {
    /// The capacity (number of valid values).
    @inlinable
    public static func capacity<let N: Int>() -> Cardinal
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        Finite.Bound<N>.capacity
    }

    /// The maximum valid position (N - 1), or nil if N == 0.
    @inlinable
    public static func max<let N: Int>() -> Self?
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        guard N > 0 else { return nil }
        return Self(__unchecked: N - 1)
    }
}

// MARK: - Successor / Predecessor

extension Tagged where Tag: ~Copyable {
    /// The next position, or nil if at maximum.
    @inlinable
    public func successor<let N: Int>() -> Self?
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        let next = rawValue + Cardinal.one
        guard next < Finite.Bound<N>.capacity else { return nil }
        return Self(__unchecked: (), next)
    }

    /// The previous position, or nil if at zero.
    @inlinable
    public func predecessor<let N: Int>() -> Self?
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        guard let previous = try? rawValue.predecessor.exact() else { return nil }
        return Self(__unchecked: (), previous)
    }
}

// MARK: - Offset

extension Tagged where Tag: ~Copyable {
    /// Returns a position offset by delta, or nil if out of bounds.
    @inlinable
    public func offset<let N: Int>(by delta: Int) -> Self?
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        let current = Int(bitPattern: self)
        let result = current + delta
        guard result >= 0, result < N else { return nil }
        return Self(__unchecked: result)
    }

    /// Returns a position offset by delta, clamped to valid bounds.
    @inlinable
    public func clamped<let N: Int>(offsetBy delta: Int) -> Self
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        let current = Int(bitPattern: self)
        let result = current + delta
        if result < 0 { return Self(__unchecked: (), .zero) }
        if result >= N { return Self(__unchecked: N - 1) }
        return Self(__unchecked: result)
    }
}

// MARK: - Distance

extension Tagged where Tag: ~Copyable {
    /// The signed distance from this position to another.
    @inlinable
    public func distance<let N: Int>(to other: Self) -> Int
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        Int(bitPattern: other) - Int(bitPattern: self)
    }
}

// MARK: - Complement

extension Tagged where Tag: ~Copyable {
    /// The complement: position N - 1 - self.
    ///
    /// Maps 0 → max, 1 → max-1, etc. For `Ordinal.Finite<3>`:
    /// - 0 → 2
    /// - 1 → 1
    /// - 2 → 0
    @inlinable
    public func complement<let N: Int>() -> Self
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        Self(__unchecked: N - 1 - Int(bitPattern: self))
    }
}

// MARK: - Injection / Projection

extension Tagged where Tag: ~Copyable {
    /// Injects into a larger bounded ordinal.
    ///
    /// Safe upcast: any value valid for N is valid for M where M >= N.
    @inlinable
    public func injected<let N: Int, let M: Int>() -> Tagged<Finite.Bound<M>, Ordinal>
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        Tagged<Finite.Bound<M>, Ordinal>(__unchecked: (), rawValue)
    }

    /// Projects into a smaller bounded ordinal.
    ///
    /// Returns nil if the current value exceeds M - 1.
    @inlinable
    public func projected<let N: Int, let M: Int>() -> Tagged<Finite.Bound<M>, Ordinal>?
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        guard rawValue < Finite.Bound<M>.capacity else { return nil }
        return Tagged<Finite.Bound<M>, Ordinal>(__unchecked: (), rawValue)
    }
}

// MARK: - Product Isomorphism (Fin (m×n) ≅ Fin m × Fin n)

extension Tagged where Tag: ~Copyable {
    /// Decomposes this ordinal into row and column coordinates.
    ///
    /// Interprets `self` as a row-major index in a grid with `Columns` columns:
    /// - row = `position / Columns`
    /// - column = `position % Columns`
    ///
    /// ## Example
    ///
    /// ```swift
    /// // 3×4 grid, index 7 → row 1, column 3
    /// let index: Ordinal.Finite<12> = Ordinal.Finite(7)!
    /// let (row, column) = index.decomposed(rows: 3, columns: 4)!
    /// // row == 1, column == 3
    /// ```
    ///
    /// - Returns: `(row, column)`, or `nil` if `Rows × Columns ≠ N`.
    @inlinable
    public func decomposed<let N: Int, let Rows: Int, let Columns: Int>()
        -> (row: Tagged<Finite.Bound<Rows>, Ordinal>, column: Tagged<Finite.Bound<Columns>, Ordinal>)?
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        guard Rows * Columns == N else { return nil }
        let position = Int(bitPattern: self)
        let row = position / Columns
        let column = position % Columns
        return (
            Tagged<Finite.Bound<Rows>, Ordinal>(__unchecked: row),
            Tagged<Finite.Bound<Columns>, Ordinal>(__unchecked: column)
        )
    }

    /// Creates an ordinal from row and column indices (row-major linear index).
    ///
    /// Computes the row-major linear index: `row × Columns + column`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // 3×4 grid, row 1, column 3 → index 7
    /// let row: Ordinal.Finite<3> = Ordinal.Finite(1)!
    /// let column: Ordinal.Finite<4> = Ordinal.Finite(3)!
    /// let index: Ordinal.Finite<12> = .composed(row: row, column: column)!
    /// // index == 7
    /// ```
    ///
    /// - Returns: The combined ordinal, or `nil` if `Rows × Columns ≠ N`.
    @inlinable
    public static func composed<let N: Int, let Rows: Int, let Columns: Int>(
        row: Tagged<Finite.Bound<Rows>, Ordinal>,
        column: Tagged<Finite.Bound<Columns>, Ordinal>
    ) -> Self?
    where Tag == Finite.Bound<N>, RawValue == Ordinal {
        guard Rows * Columns == N else { return nil }
        let position = Int(bitPattern: row) * Columns + Int(bitPattern: column)
        return Self(__unchecked: position)
    }
}
