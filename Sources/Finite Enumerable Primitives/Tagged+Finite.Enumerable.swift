// Tagged+Finite.Enumerable.swift
// Finite.Enumerable conformance for Tagged<Finite.Bound<N>, Ordinal>.

import Cardinal_Primitives
public import Finite_Capacity_Primitives
public import Finite_Primitive
import Ordinal_Primitives
import Tagged_Primitives

extension Tagged: @retroactive CaseIterable where Tag: Finite.Capacity, Underlying == Ordinal {}

extension Tagged: Finite.Enumerable where Tag: Finite.Capacity, Underlying == Ordinal {
    /// Number of distinct values.
    @inlinable
    public static var count: Cardinal { Tag.capacity }

    /// Ordinal position of this value.
    @inlinable
    public var ordinal: Ordinal { underlying }

    /// Creates a value from its ordinal without bounds checking.
    @inlinable
    public init(_unchecked: Void, ordinal: Ordinal) {
        self.init(_unchecked: ordinal)
    }
}
