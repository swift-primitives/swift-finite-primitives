// Parity+Finite.swift

extension Parity: Finite.Enumerable {
    /// Number of parity values.
    @inlinable
    public static var count: Cardinal { 2 }

    /// Ordinal of this value (0: even, 1: odd).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .even: 0
        case .odd: 1
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.even, .odd][ordinal]
    }
}
