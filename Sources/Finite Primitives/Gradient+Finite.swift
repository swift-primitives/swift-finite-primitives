// Gradient+Finite.swift

extension Gradient: Finite.Enumerable {
    /// Number of gradient values.
    @inlinable
    public static var count: Cardinal { 2 }

    /// Ordinal of this value (0: ascending, 1: descending).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .ascending: 0
        case .descending: 1
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.ascending, .descending][ordinal]
    }
}
