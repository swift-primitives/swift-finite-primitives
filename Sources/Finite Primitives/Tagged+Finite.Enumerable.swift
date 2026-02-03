// Tagged+Finite.Enumerable.swift
// Finite.Enumerable conformance for Tagged<Finite.Bound<N>, Ordinal>.

import Ordinal_Primitives
import Identity_Primitives

extension Tagged: @retroactive CaseIterable where Tag: Finite.Capacity, RawValue == Ordinal {}

extension Tagged: Finite.Enumerable where Tag: Finite.Capacity, RawValue == Ordinal {
    /// Number of distinct values.
    @inlinable
    public static var count: Cardinal { Cardinal(UInt(Tag.capacity)) }

    /// Ordinal position of this value.
    @inlinable
    public var ordinal: Ordinal { rawValue }

    /// Creates a value from its ordinal without bounds checking.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self.init(__unchecked: (), ordinal)
    }
}
