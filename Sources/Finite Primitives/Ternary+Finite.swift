// Ternary+Finite.swift

extension Ternary: Finite.Enumerable {
    /// Number of ternary values.
    @inlinable
    public static var count: Cardinal { 3 }

    /// Ordinal of this value (0: negative, 1: zero, 2: positive).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .negative: 0
        case .zero: 1
        case .positive: 2
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.negative, .zero, .positive][ordinal]
    }
}
