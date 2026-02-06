// Comparison+Finite.swift
// Finite extensions for Comparison from comparison-primitives.

// MARK: - Tagged Value

extension Comparison {
    /// A value paired with a comparison result.
    public typealias Value<Payload> = Pair<Comparison, Payload>
}

// MARK: - Finite.Enumerable

extension Comparison: Finite.Enumerable {
    /// Number of comparison values.
    @inlinable
    public static var count: Cardinal { 3 }

    /// Ordinal of this value (0: less, 1: equal, 2: greater).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .less: 0
        case .equal: 1
        case .greater: 2
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.less, .equal, .greater][ordinal]
    }
}
