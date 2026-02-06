// Polarity+Finite.swift

extension Polarity: Finite.Enumerable {
    /// Number of polarity values.
    @inlinable
    public static var count: Cardinal { 3 }

    /// Ordinal of this value (0: positive, 1: negative, 2: neutral).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .positive: 0
        case .negative: 1
        case .neutral: 2
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.positive, .negative, .neutral][ordinal]
    }
}
