// Boundary+Finite.swift

extension Boundary: Finite.Enumerable {
    /// Number of boundary values.
    @inlinable
    public static var count: Cardinal { 2 }

    /// Ordinal of this value (0: closed, 1: open).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .closed: 0
        case .open: 1
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.closed, .open][ordinal]
    }
}
