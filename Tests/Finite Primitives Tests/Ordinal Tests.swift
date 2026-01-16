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
    func `zero property`() {
        let zero: Finite.Ordinal<10> = .zero
        #expect(zero.rawValue == 0)
    }

    @Test
    func `max property`() {
        let max: Finite.Ordinal<5> = .max
        #expect(max.rawValue == 4)
    }

    @Test
    func `count property`() {
        #expect(Finite.Ordinal<3>.count == 3)
        #expect(Finite.Ordinal<10>.count == 10)
        #expect(Finite.Ordinal<1>.count == 1)
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
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(unchecked: value)
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
    func `Enumerable caseCount`() {
        #expect(Finite.Ordinal<5>.caseCount == 5)
        #expect(Finite.Ordinal<10>.caseCount == 10)
    }

    @Test(arguments: [0, 1, 2, 3])
    func `Enumerable caseIndex`(index: Int) {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(index)!
        #expect(ordinal.caseIndex == index)
    }

    @Test(arguments: [0, 1, 2, 3])
    func `Enumerable init from caseIndex`(index: Int) {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(caseIndex: index)
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
