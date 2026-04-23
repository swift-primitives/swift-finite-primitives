// Index.Bounded.swift
// Capacity-bounded index typealias and bridging.

import Index_Primitives
import Ordinal_Primitives
import Tagged_Primitives

// MARK: - Typealias

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// A capacity-bounded index guaranteed to be in the range [0, N).
    ///
    /// `Index<Element>.Bounded<N>` wraps `Ordinal.Finite<N>` with the
    /// same phantom `Element` tag as the unbounded `Index<Element>`.
    /// This eliminates capacity and non-negativity preconditions
    /// at subscript call sites — only the `index < count` check remains.
    ///
    /// ## Type Structure
    ///
    /// ```
    /// Index<Element>.Bounded<N>
    /// = Tagged<Element, Ordinal.Finite<N>>
    /// = Tagged<Element, Tagged<Finite.Bound<N>, Ordinal>>
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let index: Index<Int> = ...
    /// let bounded: Index<Int>.Bounded<8>? = .init(index)
    /// // bounded >= 0: guaranteed (Ordinal is non-negative)
    /// // bounded < 8:  guaranteed (Finite<8> is bounded)
    /// ```
    public typealias Bounded<let N: Int> = Tagged<Tag, Ordinal.Finite<N>>
}

// MARK: - Narrowing: Index<Element> → Index<Element>.Bounded<N>

extension Tagged where Tag: ~Copyable {
    /// Creates a capacity-bounded index from an unbounded index.
    ///
    /// Returns `nil` if the index is outside the range [0, N).
    @inlinable
    public init?<let N: Int>(_ index: Tagged<Tag, Ordinal>)
    where RawValue == Tagged<Finite.Bound<N>, Ordinal> {
        guard let finite = Ordinal.Finite<N>(index.rawValue) else { return nil }
        self.init(__unchecked: (), finite)
    }
}

// MARK: - Widening: Index<Element>.Bounded<N> → Index<Element>

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// Creates an unbounded index from a capacity-bounded index.
    @inlinable
    public init<let N: Int>(_ bounded: Tagged<Tag, Ordinal.Finite<N>>) {
        self = bounded.map { $0.rawValue }
    }
}
