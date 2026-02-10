// Finite.Enumeration.swift
// Zero-allocation sequence over Enumerable types.

import Ordinal_Primitives
import Index_Primitives

extension Finite {
    /// A zero-allocation, lazy sequence over an `Enumerable` type.
    ///
    /// `Enumeration` provides efficient iteration with O(1) subscript access,
    /// conforming to `RandomAccessCollection`. It's a zero-size type with no
    /// stored properties—all information comes from the `Element` type's
    /// static properties.
    ///
    /// ## Example
    ///
    /// ```swift
    /// for value in MyEnumerableType.allCases { ... }
    /// let third = MyEnumerableType.allCases[2]  // O(1) random access
    /// ```
    public struct Enumeration<Element: Finite.Enumerable>: Swift.Sequence, Sendable {
        /// Creates a sequence over all values of the element type.
        @inlinable
        public init() {}

        /// Returns an iterator over all values.
        @inlinable
        public func makeIterator() -> Iterator {
            Iterator()
        }

        /// Iterator that lazily produces each value in index order.
        public struct Iterator: IteratorProtocol, Sendable {
            @usableFromInline
            var index: Ordinal_Primitives.Ordinal = .zero

            @inlinable
            init() {}

            /// Returns the next value, or `nil` if exhausted.
            @inlinable
            public mutating func next() -> Element? {
                guard index < Element.count else { return nil }  // Ordinal < Cardinal (disfavored overload)
                defer { index = index + Cardinal.one }           // Ordinal + Cardinal → Ordinal
                return Element(__unchecked: (), ordinal: index)
            }
        }
    }
}

// MARK: - Total Element Access

extension Finite.Enumeration {
    /// Returns the element at the given position, or `nil` if out of bounds.
    ///
    /// This is the total, safe accessor. For trusted indices where bounds
    /// are already guaranteed (e.g., from iteration), use `subscript` instead.
    ///
    /// - Parameter position: The index to access.
    /// - Returns: The element at that position, or `nil` if out of bounds.
    @inlinable
    public func element(at position: Int) -> Element? {
        guard let ordinal = Ordinal_Primitives.Ordinal(exactly: position) else { return nil }
        return Element(ordinal)
    }
}

// MARK: - Enumeration: Collection

extension Finite.Enumeration: Swift.Collection {
    /// Phantom-typed index for type-safe collection access.
    public typealias Index = Index_Primitives.Index<Element>

    /// Position of the first element.
    @inlinable
    public var startIndex: Index { .zero }

    /// Position past the last element.
    @inlinable
    public var endIndex: Index { Index.Count(Element.count).map(Ordinal.init) }

    /// Returns the element at the given position.
    ///
    /// This follows `Collection` semantics: the subscript is unchecked.
    /// For safe access with untrusted input, use `element(at:)` instead.
    ///
    /// - Parameter position: Must be in `startIndex..<endIndex`.
    @inlinable
    public subscript(position: Index) -> Element {
        Element(__unchecked: (), ordinal: position.position)
    }

    /// Returns the position immediately after the given index.
    @inlinable
    public func index(after i: Index) -> Index {
        i + Index.Count(Cardinal.one)
    }
}

// MARK: - Enumeration: BidirectionalCollection

extension Finite.Enumeration: BidirectionalCollection {
    /// Returns the position immediately before the given index.
    @inlinable
    public func index(before i: Index) -> Index {
        // BidirectionalCollection guarantees i > startIndex.
        try! i.predecessor.exact()
    }
}

// MARK: - Enumeration: RandomAccessCollection

extension Finite.Enumeration: RandomAccessCollection {
    /// Number of elements.
    @inlinable
    public var count: Int { Int(clamping: Element.count) }

    /// Returns the distance between two indices.
    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        Int(bitPattern: end.position) - Int(bitPattern: start.position)
    }

    /// Returns an index offset by the given distance.
    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        Index(__unchecked: (), Ordinal(UInt(bitPattern: Int(bitPattern: i.position) + distance)))
    }

    /// Returns an index offset by the given distance, limited by a boundary.
    @inlinable
    public func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        let result = Int(bitPattern: i.position) + distance
        if distance >= 0 {
            return result <= Int(bitPattern: limit.position) ? Index(__unchecked: (), Ordinal(UInt(bitPattern: result))) : nil
        } else {
            return result >= Int(bitPattern: limit.position) ? Index(__unchecked: (), Ordinal(UInt(bitPattern: result))) : nil
        }
    }
}
