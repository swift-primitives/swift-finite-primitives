// Sign+Finite.swift

extension Sign: Finite.Enumerable {
    /// Number of sign values.
    @inlinable
    public static var count: Cardinal { 3 }

    /// Ordinal of this value (0: positive, 1: negative, 2: zero).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .positive: 0
        case .negative: 1
        case .zero: 2
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.positive, .negative, .zero][ordinal]
    }
}
