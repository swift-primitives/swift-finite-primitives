// Ordinal.Finite.swift
// Bounded ordinal typealias.

import Ordinal_Primitives
import Tagged_Primitives

// MARK: - Typealias

extension Ordinal {
    /// A bounded ordinal with compile-time capacity N.
    ///
    /// `Ordinal.Finite<N>` represents positions in the range [0, N).
    /// Unlike unbounded `Ordinal`, arithmetic operations are bounds-checked
    /// and return `nil` when exceeding the capacity.
    ///
    /// This type is `Tagged<Finite.Bound<N>, Ordinal>`, giving it automatic access
    /// to ordinal arithmetic through generic extensions on `Tagged`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var idx: Ordinal.Finite<4> = .zero
    /// idx = idx.successor()!  // 1
    /// idx = idx.successor()!  // 2
    /// idx = idx.successor()!  // 3
    /// idx.successor()         // nil (at bound)
    /// ```
    ///
    /// ## Arithmetic
    ///
    /// Ordinal.Finite<N> inherits ordinal arithmetic from `Tagged<*, Ordinal>`:
    /// - `.position` — the underlying `Ordinal`
    /// - `.zero` — the zero position
    /// - `distance(to:)` — signed distance between positions
    ///
    /// Bounded operations check against N:
    /// - `successor()` — next position, nil if at max
    /// - `predecessor()` — previous position, nil if at zero
    /// - `offset(by:)` — offset by delta, nil if out of bounds
    /// - `capacity()` — the bound N
    public typealias Finite<let N: Int> = Tagged<Finite_Primitives_Core.Finite.Bound<N>, Ordinal>
}
