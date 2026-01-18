// Ordinal Tests.swift

import Test_Primitives
import Testing

@testable import Finite_Primitives

// MARK: - Ordinal - Properties

@Suite
struct `Ordinal - Properties` {
    @Test(arguments: [0, 1, 2])
    func `rawValue accessor`(value: Int) {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(value)!
        #expect(ordinal.rawValue == value)
    }

    @Test
    func `count property`() {
        #expect(Finite.Ordinal<3>.count == 3)
        #expect(Finite.Ordinal<10>.count == 10)
        #expect(Finite.Ordinal<1>.count == 1)
        #expect(Finite.Ordinal<0>.count == 0)
    }
}

// MARK: - Ordinal - Successor / Predecessor

@Suite
struct `Ordinal - Successor and Predecessor` {
    @Test
    func `successor returns next value`() {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(2)!
        let next = ordinal.successor()
        #expect(next?.rawValue == 3)
    }

    @Test
    func `successor returns nil at max`() {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(4)!
        let next = ordinal.successor()
        #expect(next == nil)
    }

    @Test
    func `predecessor returns previous value`() {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(2)!
        let previous = ordinal.predecessor()
        #expect(previous?.rawValue == 1)
    }

    @Test
    func `predecessor returns nil at zero`() {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(0)!
        let previous = ordinal.predecessor()
        #expect(previous == nil)
    }
}

// MARK: - Ordinal - Distance / Offset

@Suite
struct `Ordinal - Distance and Offset` {
    @Test
    func `distance to calculates signed distance`() {
        let a: Finite.Ordinal<10> = Finite.Ordinal(2)!
        let b: Finite.Ordinal<10> = Finite.Ordinal(7)!
        #expect(a.distance(to: b) == 5)
        #expect(b.distance(to: a) == -5)
    }

    @Test
    func `offset returns shifted ordinal`() {
        let ordinal: Finite.Ordinal<10> = Finite.Ordinal(5)!
        #expect(ordinal.offset(by: 2)?.rawValue == 7)
        #expect(ordinal.offset(by: -3)?.rawValue == 2)
    }

    @Test
    func `offset returns nil when out of bounds`() {
        let ordinal: Finite.Ordinal<10> = Finite.Ordinal(5)!
        #expect(ordinal.offset(by: 10) == nil)
        #expect(ordinal.offset(by: -6) == nil)
    }

    @Test
    func `offset clamped stays within bounds`() {
        let ordinal: Finite.Ordinal<10> = Finite.Ordinal(5)!
        #expect(ordinal.offset.clamped(by: 100).rawValue == 9)
        #expect(ordinal.offset.clamped(by: -100).rawValue == 0)
        #expect(ordinal.offset.clamped(by: 2).rawValue == 7)
    }
}

// MARK: - Ordinal - Product Isomorphism

@Suite
struct `Ordinal - Product Isomorphism` {
    @Test
    func `decomposed extracts row and column`() {
        let index: Finite.Ordinal<12> = Finite.Ordinal(7)!
        let result: (Finite.Ordinal<3>, Finite.Ordinal<4>)? = index.decomposed()
        #expect(result?.0.rawValue == 1)  // row
        #expect(result?.1.rawValue == 3)  // column
    }

    @Test
    func `decomposed returns nil for mismatched dimensions`() {
        let index: Finite.Ordinal<12> = Finite.Ordinal(7)!
        let result: (Finite.Ordinal<5>, Finite.Ordinal<5>)? = index.decomposed()
        #expect(result == nil)
    }

    @Test
    func `init from row and column combines correctly`() {
        let row: Finite.Ordinal<3> = Finite.Ordinal(1)!
        let column: Finite.Ordinal<4> = Finite.Ordinal(3)!
        let index: Finite.Ordinal<12>? = .init(row: row, column: column)
        #expect(index?.rawValue == 7)
    }

    @Test
    func `init from row and column returns nil for mismatched dimensions`() {
        let row: Finite.Ordinal<3> = Finite.Ordinal(1)!
        let column: Finite.Ordinal<4> = Finite.Ordinal(3)!
        let index: Finite.Ordinal<10>? = .init(row: row, column: column)
        #expect(index == nil)
    }

    @Test
    func `decomposed and init are inverses`() {
        for i in 0..<12 {
            let index: Finite.Ordinal<12> = Finite.Ordinal(i)!
            let (row, column): (Finite.Ordinal<3>, Finite.Ordinal<4>) = index.decomposed()!
            let reconstructed: Finite.Ordinal<12> = .init(row: row, column: column)!
            #expect(reconstructed == index)
        }
    }
}

// MARK: - Ordinal - Initializers

@Suite
struct `Ordinal - Initializers` {
    @Test(arguments: [0, 1, 2, 3, 4])
    func `init with valid value`(value: Int) {
        let ordinal: Finite.Ordinal<5>? = Finite.Ordinal(value)
        #expect(ordinal != nil)
        #expect(ordinal?.rawValue == value)
    }

    @Test(arguments: [-1, 5, 10, 100])
    func `init with invalid value returns nil`(value: Int) {
        let ordinal: Finite.Ordinal<5>? = Finite.Ordinal(value)
        #expect(ordinal == nil)
    }

    @Test(arguments: [0, 1, 2])
    func `init unchecked creates ordinal without validation`(value: Int) {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(__unchecked: (), value)
        #expect(ordinal.rawValue == value)
    }
}

// MARK: - Ordinal - Conversion

@Suite
struct `Ordinal - Conversion` {
    @Test
    func `injected safely converts to larger domain`() {
        let ord2: Finite.Ordinal<2> = Finite.Ordinal(0)!
        let ord5: Finite.Ordinal<5> = ord2.injected()
        #expect(ord5.rawValue == 0)
    }

    @Test(arguments: [0, 1])
    func `injected preserves raw value`(value: Int) {
        let ord2: Finite.Ordinal<2> = Finite.Ordinal(value)!
        let ord10: Finite.Ordinal<10> = ord2.injected()
        #expect(ord10.rawValue == value)
    }

    @Test
    func `projected converts to smaller domain when valid`() {
        let ord10: Finite.Ordinal<10> = Finite.Ordinal(2)!
        let ord5: Finite.Ordinal<5>? = ord10.projected()
        #expect(ord5?.rawValue == 2)
    }

    @Test
    func `projected returns nil when value too large`() {
        let ord10: Finite.Ordinal<10> = Finite.Ordinal(7)!
        let ord5: Finite.Ordinal<5>? = ord10.projected()
        #expect(ord5 == nil)
    }
}

// MARK: - Ordinal - Protocol Conformances

@Suite
struct `Ordinal - Protocol Conformances` {
    @Test
    func `Equatable reflexivity`() {
        let ord1: Finite.Ordinal<5> = Finite.Ordinal(2)!
        let ord2: Finite.Ordinal<5> = Finite.Ordinal(2)!
        let ord3: Finite.Ordinal<5> = Finite.Ordinal(3)!
        #expect(ord1 == ord2)
        #expect(ord1 != ord3)
    }

    @Test
    func `Hashable produces unique hashes`() {
        let set: Set<Finite.Ordinal<5>> = [Finite.Ordinal(0)!, Finite.Ordinal(1)!, Finite.Ordinal(0)!]
        #expect(set.count == 2)
    }

    @Test
    func `Comparable ordering`() {
        let ord1: Finite.Ordinal<5> = Finite.Ordinal(1)!
        let ord2: Finite.Ordinal<5> = Finite.Ordinal(3)!
        #expect(ord1 < ord2)
        #expect(ord2 > ord1)
    }

    @Test
    func `Enumerable count`() {
        #expect(Finite.Ordinal<5>.count == 5)
        #expect(Finite.Ordinal<10>.count == 10)
    }

    @Test(arguments: [0, 1, 2, 3])
    func `Enumerable ordinal`(index: Int) {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(index)!
        #expect(ordinal.ordinal == index)
    }

    @Test(arguments: [0, 1, 2, 3])
    func `Enumerable init __unchecked`(index: Int) {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(__unchecked: (), index)
        #expect(ordinal.rawValue == index)
    }

    @Test
    func `CaseIterable allCases`() {
        let allCases = Array(Finite.Ordinal<3>.allCases)
        #expect(allCases.count == 3)
        #expect(allCases[0].rawValue == 0)
        #expect(allCases[1].rawValue == 1)
        #expect(allCases[2].rawValue == 2)
    }
}

// MARK: - Ordinal - Array Subscripting

@Suite
struct `Ordinal - Array Subscripting` {
    @Test
    func `array subscript with ordinal`() {
        let array = ["a", "b", "c", "d", "e"]
        let index: Finite.Ordinal<5> = Finite.Ordinal(2)!
        #expect(array[index] == "c")
    }

    @Test(arguments: [0, 1, 2, 3])
    func `array subscript type safety`(value: Int) {
        let array = [10, 20, 30, 40]
        let index: Finite.Ordinal<4> = Finite.Ordinal(value)!
        let expected = array[value]
        #expect(array[index] == expected)
    }
}

// MARK: - Ordinal - Type Alias

@Suite
struct `Ordinal - Type Alias` {
    @Test
    func `Fin is alias for Ordinal`() {
        let ord: Finite.Ordinal<5> = Finite.Ordinal(2)!
        let fin: Finite.Fin<5> = Finite.Fin(2)!
        #expect(ord.rawValue == fin.rawValue)
    }
}
