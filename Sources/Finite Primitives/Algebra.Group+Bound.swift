// Algebra.Group+Bound.swift

/// Z₂ group witness for Bound.
///
/// Bound forms a Z₂ group under the swap operation:
/// - Identity: lower
/// - lower ∗ lower = lower, upper ∗ upper = lower
/// - lower ∗ upper = upper, upper ∗ lower = upper
/// - Every element is its own inverse
extension Algebra.Group where Element == Bound {
    /// The Z₂ group over bound position.
    @inlinable
    public static var z2: Self {
        .z2(via: .init(
            forward: { $0 == .lower ? .even : .odd },
            backward: { $0 == .even ? .lower : .upper }
        ))
    }
}
