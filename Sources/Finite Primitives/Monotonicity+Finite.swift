// Monotonicity+Finite.swift

extension Monotonicity: Finite.Enumerable {
    /// Number of monotonicity values.
    @inlinable
    public static var count: Cardinal { 3 }

    /// Ordinal of this value (0: increasing, 1: decreasing, 2: constant).
    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .increasing: 0
        case .decreasing: 1
        case .constant: 2
        }
    }

    /// Creates a value from its ordinal.
    @inlinable
    public init(__unchecked: Void, ordinal: Ordinal) {
        self = [.increasing, .decreasing, .constant][ordinal]
    }
}
