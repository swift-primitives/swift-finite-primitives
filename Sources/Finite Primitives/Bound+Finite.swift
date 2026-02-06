// Bound+Finite.swift

extension Bound: Finite.Enumerable {
    /// Number of bound values.
    @inlinable
    public static var count: Cardinal { 2 }

    /// Ordinal of this value (0: lower, 1: upper).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .lower: 0
        case .upper: 1
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.lower, .upper][ordinal]
    }
}
