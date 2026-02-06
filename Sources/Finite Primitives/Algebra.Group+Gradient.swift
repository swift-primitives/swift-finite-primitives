// Algebra.Group+Gradient.swift

/// Z₂ group witness for Gradient.
///
/// Gradient forms a Z₂ group under the reversal operation:
/// - Identity: ascending
/// - ascending ∗ ascending = ascending, descending ∗ descending = ascending
/// - ascending ∗ descending = descending, descending ∗ ascending = descending
/// - Every element is its own inverse
extension Algebra.Group where Element == Gradient {
    /// The Z₂ group over gradient direction.
    @inlinable
    public static var z2: Self {
        .z2(via: .init(
            forward: { $0 == .ascending ? .even : .odd },
            backward: { $0 == .even ? .ascending : .descending }
        ))
    }
}
