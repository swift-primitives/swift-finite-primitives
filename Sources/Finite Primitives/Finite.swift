// Finite.swift
// Namespace for finite type infrastructure.

/// Namespace for finite type infrastructure.
///
/// `Finite` contains types for working with finite sets—types that have
/// a known, countable number of inhabitants that can be indexed.
///
/// ## Core Types
///
/// - ``Enumerable``: Protocol for types with finitely many indexed inhabitants
/// - ``Enumeration``: Zero-allocation collection over enumerable types
/// - ``Ordinal``: The canonical finite type with exactly N inhabitants (Fin n)
///
/// ## Example
///
/// ```swift
/// // Define a finite type
/// struct CardSuit: Finite.Enumerable {
///     static let caseCount = 4
///     let caseIndex: Int
///     init(caseIndex: Int) { self.caseIndex = caseIndex }
/// }
///
/// // Use the canonical finite type
/// let index: Finite.Ordinal<4> = Finite.Ordinal(2)!
/// ```
public enum Finite: Sendable {}
