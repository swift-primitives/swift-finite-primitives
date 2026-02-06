// Algebra.Group+Endpoint.swift

/// Z₂ group witness for Endpoint.
///
/// Endpoint forms a Z₂ group under the swap operation:
/// - Identity: start
/// - start ∗ start = start, end ∗ end = start
/// - start ∗ end = end, end ∗ start = end
/// - Every element is its own inverse
extension Algebra.Group where Element == Endpoint {
    /// The Z₂ group over endpoint position.
    @inlinable
    public static var z2: Self {
        .z2(via: .init(
            forward: { $0 == .start ? .even : .odd },
            backward: { $0 == .even ? .start : .end }
        ))
    }
}
