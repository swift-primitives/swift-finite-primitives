// Ordinal Tests.swift
// Tests for Ordinal.Finite<N> = Tagged<Finite.Bound<N>, Ordinal>

import Test_Primitives
import Testing

@testable import Finite_Primitives

// MARK: - Ordinal.Finite - Properties

@Suite
struct `Ordinal_Finite - Properties` {
    @Test(arguments: [0, 1, 2])
    func `position accessor`(value: Int) {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(value)!
        #expect(ordinal.position.rawValue == UInt(value))
    }

    @Test(arguments: [0, 1, 2])
    func `intValue accessor`(value: Int) {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(value)!
        #expect(ordinal.intValue == value)
    }

    @Test
    func `capacity property`() {
        #expect(Ordinal.Finite<3>.capacity() == 3)
        #expect(Ordinal.Finite<10>.capacity() == 10)
        #expect(Ordinal.Finite<1>.capacity() == 1)
        #expect(Ordinal.Finite<0>.capacity() == 0)
    }

    @Test
    func `max property`() {
        #expect(Ordinal.Finite<5>.max()?.intValue == 4)
        #expect(Ordinal.Finite<1>.max()?.intValue == 0)
        #expect(Ordinal.Finite<0>.max() == nil)
    }

    @Test
    func `zero property`() {
        let zero: Ordinal.Finite<5> = .zero
        #expect(zero.intValue == 0)
    }
}

// MARK: - Ordinal.Finite - Successor / Predecessor

@Suite
struct `Ordinal_Finite - Successor and Predecessor` {
    @Test
    func `successor returns next value`() {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(2)!
        let next = ordinal.successor()
        #expect(next?.intValue == 3)
    }

    @Test
    func `successor returns nil at max`() {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(4)!
        let next = ordinal.successor()
        #expect(next == nil)
    }

    @Test
    func `predecessor returns previous value`() {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(2)!
        let previous = ordinal.predecessor()
        #expect(previous?.intValue == 1)
    }

    @Test
    func `predecessor returns nil at zero`() {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(0)!
        let previous = ordinal.predecessor()
        #expect(previous == nil)
    }

    @Test
    func `successor chain`() {
        var ordinal: Ordinal.Finite<4> = .zero
        var values: [Int] = [ordinal.intValue]
        while let next = ordinal.successor() {
            ordinal = next
            values.append(ordinal.intValue)
        }
        #expect(values == [0, 1, 2, 3])
    }
}

// MARK: - Ordinal.Finite - Distance / Offset

@Suite
struct `Ordinal_Finite - Distance and Offset` {
    @Test
    func `distance to calculates signed distance`() {
        let a: Ordinal.Finite<10> = Ordinal.Finite(2)!
        let b: Ordinal.Finite<10> = Ordinal.Finite(7)!
        #expect(a.distance(to: b) == 5)
        #expect(b.distance(to: a) == -5)
    }

    @Test
    func `offset returns shifted ordinal`() {
        let ordinal: Ordinal.Finite<10> = Ordinal.Finite(5)!
        #expect(ordinal.offset(by: 2)?.intValue == 7)
        #expect(ordinal.offset(by: -3)?.intValue == 2)
    }

    @Test
    func `offset returns nil when out of bounds`() {
        let ordinal: Ordinal.Finite<10> = Ordinal.Finite(5)!
        #expect(ordinal.offset(by: 10) == nil)
        #expect(ordinal.offset(by: -6) == nil)
    }

    @Test
    func `clamped offsetBy stays within bounds`() {
        let ordinal: Ordinal.Finite<10> = Ordinal.Finite(5)!
        #expect(ordinal.clamped(offsetBy: 100).intValue == 9)
        #expect(ordinal.clamped(offsetBy: -100).intValue == 0)
        #expect(ordinal.clamped(offsetBy: 2).intValue == 7)
    }
}

// MARK: - Ordinal.Finite - Complement

@Suite
struct `Ordinal_Finite - Complement` {
    @Test
    func `complement mirrors position`() {
        #expect(Ordinal.Finite<4>(0)!.complement().intValue == 3)
        #expect(Ordinal.Finite<4>(1)!.complement().intValue == 2)
        #expect(Ordinal.Finite<4>(2)!.complement().intValue == 1)
        #expect(Ordinal.Finite<4>(3)!.complement().intValue == 0)
    }

    @Test
    func `complement is involution`() {
        for i in 0..<5 {
            let ordinal = Ordinal.Finite<5>(i)!
            #expect(ordinal.complement().complement() == ordinal)
        }
    }
}

// MARK: - Ordinal.Finite - Product Isomorphism

@Suite
struct `Ordinal_Finite - Product Isomorphism` {
    @Test
    func `decomposed extracts row and column`() {
        let index: Ordinal.Finite<12> = Ordinal.Finite(7)!
        let result: (Ordinal.Finite<3>, Ordinal.Finite<4>)? = index.decomposed()
        #expect(result?.0.intValue == 1)  // row
        #expect(result?.1.intValue == 3)  // column
    }

    @Test
    func `decomposed returns nil for mismatched dimensions`() {
        let index: Ordinal.Finite<12> = Ordinal.Finite(7)!
        let result: (Ordinal.Finite<5>, Ordinal.Finite<5>)? = index.decomposed()
        #expect(result == nil)
    }

    @Test
    func `composed from row and column combines correctly`() {
        let row: Ordinal.Finite<3> = Ordinal.Finite(1)!
        let column: Ordinal.Finite<4> = Ordinal.Finite(3)!
        let index: Ordinal.Finite<12>? = .composed(row: row, column: column)
        #expect(index?.intValue == 7)
    }

    @Test
    func `composed returns nil for mismatched dimensions`() {
        let row: Ordinal.Finite<3> = Ordinal.Finite(1)!
        let column: Ordinal.Finite<4> = Ordinal.Finite(3)!
        let index: Ordinal.Finite<10>? = .composed(row: row, column: column)
        #expect(index == nil)
    }

    @Test
    func `decomposed and composed are inverses`() {
        for i in 0..<12 {
            let index: Ordinal.Finite<12> = Ordinal.Finite(i)!
            let (row, column): (Ordinal.Finite<3>, Ordinal.Finite<4>) = index.decomposed()!
            let reconstructed: Ordinal.Finite<12> = .composed(row: row, column: column)!
            #expect(reconstructed == index)
        }
    }
}

// MARK: - Ordinal.Finite - Initializers

@Suite
struct `Ordinal_Finite - Initializers` {
    @Test(arguments: [0, 1, 2, 3, 4])
    func `init from Int with valid value`(value: Int) {
        let ordinal: Ordinal.Finite<5>? = Ordinal.Finite(value)
        #expect(ordinal != nil)
        #expect(ordinal?.intValue == value)
    }

    @Test(arguments: [-1, 5, 10, 100])
    func `init from Int with invalid value returns nil`(value: Int) {
        let ordinal: Ordinal.Finite<5>? = Ordinal.Finite(value)
        #expect(ordinal == nil)
    }

    @Test(arguments: [0, 1, 2])
    func `init from Ordinal with valid value`(value: Int) {
        let ordinal: Ordinal.Finite<5>? = Ordinal.Finite(Ordinal(UInt(value)))
        #expect(ordinal != nil)
        #expect(ordinal?.intValue == value)
    }

    @Test(arguments: [0, 1, 2])
    func `init unchecked creates ordinal without validation`(value: Int) {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(__unchecked: value)
        #expect(ordinal.intValue == value)
    }
}

// MARK: - Ordinal.Finite - Injection / Projection

@Suite
struct `Ordinal_Finite - Injection and Projection` {
    @Test
    func `injected safely converts to larger domain`() {
        let ord2: Ordinal.Finite<2> = Ordinal.Finite(0)!
        let ord5: Ordinal.Finite<5> = ord2.injected()
        #expect(ord5.intValue == 0)
    }

    @Test(arguments: [0, 1])
    func `injected preserves value`(value: Int) {
        let ord2: Ordinal.Finite<2> = Ordinal.Finite(value)!
        let ord10: Ordinal.Finite<10> = ord2.injected()
        #expect(ord10.intValue == value)
    }

    @Test
    func `projected converts to smaller domain when valid`() {
        let ord10: Ordinal.Finite<10> = Ordinal.Finite(2)!
        let ord5: Ordinal.Finite<5>? = ord10.projected()
        #expect(ord5?.intValue == 2)
    }

    @Test
    func `projected returns nil when value too large`() {
        let ord10: Ordinal.Finite<10> = Ordinal.Finite(7)!
        let ord5: Ordinal.Finite<5>? = ord10.projected()
        #expect(ord5 == nil)
    }
}

// MARK: - Ordinal.Finite - Protocol Conformances

@Suite
struct `Ordinal_Finite - Protocol Conformances` {
    @Test
    func `Equatable reflexivity`() {
        let ord1: Ordinal.Finite<5> = Ordinal.Finite(2)!
        let ord2: Ordinal.Finite<5> = Ordinal.Finite(2)!
        let ord3: Ordinal.Finite<5> = Ordinal.Finite(3)!
        #expect(ord1 == ord2)
        #expect(ord1 != ord3)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Ordinal.Finite<5>> = [Ordinal.Finite(0)!, Ordinal.Finite(1)!, Ordinal.Finite(0)!]
        #expect(set.count == 2)
    }

    @Test
    func `Comparable ordering`() {
        let ord1: Ordinal.Finite<5> = Ordinal.Finite(1)!
        let ord2: Ordinal.Finite<5> = Ordinal.Finite(3)!
        #expect(ord1 < ord2)
        #expect(ord2 > ord1)
    }

    @Test
    func `Sendable conformance`() {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(2)!
        let _: any Sendable = ordinal  // Should compile
    }
}

// MARK: - Ordinal.Finite - Type Structure

@Suite
struct `Ordinal_Finite - Type Structure` {
    @Test
    func `is Tagged type`() {
        let ordinal: Ordinal.Finite<5> = .zero
        // Verify it's Tagged<Finite.Bound<5>, Ordinal>
        let _: Tagged<Finite.Bound<5>, Ordinal> = ordinal
    }

    @Test
    func `rawValue is Ordinal`() {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(3)!
        let raw: Ordinal = ordinal.rawValue
        #expect(raw.rawValue == 3)
    }

    @Test
    func `inherits Tagged Ordinal extensions`() {
        let ordinal: Ordinal.Finite<5> = Ordinal.Finite(3)!
        // .position comes from Tagged+Ordinal extensions
        let position: Ordinal = ordinal.position
        #expect(position.rawValue == 3)
    }
}
