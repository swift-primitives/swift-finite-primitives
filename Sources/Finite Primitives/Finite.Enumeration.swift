// Finite.Enumeration.swift
// Zero-allocation sequence over Enumerable types.

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
    public struct Enumeration<Element: Finite.Enumerable>: Sequence, Sendable {
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
            var index: Int = 0

            @inlinable
            init() {}

            /// Returns the next value, or `nil` if exhausted.
            @inlinable
            public mutating func next() -> Element? {
                guard index < Element.count else { return nil }
                defer { index += 1 }
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
        Element(position)
    }
}

// MARK: - Enumeration: Collection

extension Finite.Enumeration: Collection {
    /// Position of the first element (always 0).
    @inlinable
    public var startIndex: Int { 0 }

    /// Position past the last element.
    @inlinable
    public var endIndex: Int { Element.count }

    /// Returns the element at the given position.
    ///
    /// This follows `Collection` semantics: the subscript is unchecked.
    /// For safe access with untrusted input, use `element(at:)` instead.
    ///
    /// - Parameter position: Must be in `0..<Element.count`.
    @inlinable
    public subscript(position: Int) -> Element {
        Element(__unchecked: (), ordinal: position)
    }

    /// Returns the position immediately after the given index.
    @inlinable
    public func index(after i: Int) -> Int {
        i + 1
    }
}

// MARK: - Enumeration: BidirectionalCollection

extension Finite.Enumeration: BidirectionalCollection {
    /// Returns the position immediately before the given index.
    @inlinable
    public func index(before i: Int) -> Int {
        i - 1
    }
}

// MARK: - Enumeration: RandomAccessCollection

extension Finite.Enumeration: RandomAccessCollection {
    /// Number of elements.
    @inlinable
    public var count: Int { Element.count }

    /// Returns the distance between two indices.
    @inlinable
    public func distance(from start: Int, to end: Int) -> Int {
        end - start
    }

    /// Returns an index offset by the given distance.
    @inlinable
    public func index(_ i: Int, offsetBy distance: Int) -> Int {
        i + distance
    }

    /// Returns an index offset by the given distance, limited by a boundary.
    @inlinable
    public func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        let result = i + distance
        if distance >= 0 {
            return result <= limit ? result : nil
        } else {
            return result >= limit ? result : nil
        }
    }
}
