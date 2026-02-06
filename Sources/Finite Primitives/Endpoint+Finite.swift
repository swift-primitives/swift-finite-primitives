// Endpoint+Finite.swift

extension Endpoint: Finite.Enumerable {
    /// Number of endpoint values.
    @inlinable
    public static var count: Cardinal { 2 }

    /// Ordinal of this value (0: start, 1: end).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .start: 0
        case .end: 1
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.start, .end][ordinal]
    }
}
