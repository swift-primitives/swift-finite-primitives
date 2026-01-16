// Enumerable Tests.swift

import Test_Primitives
import Testing

@testable import Finite_Primitives

// MARK: - Enumerable Tests

@Suite
struct `Enumerable - Protocol` {
    // Test with Ordinal which conforms to Enumerable

    @Test
    func `caseCount returns correct count`() {
        #expect(Finite.Ordinal<5>.caseCount == 5)
        #expect(Finite.Ordinal<10>.caseCount == 10)
    }

    @Test(arguments: [0, 1, 2])
    func `caseIndex returns valid index`(index: Int) {
        let ordinal = Finite.Ordinal<5>(index)!
        let caseIdx = ordinal.caseIndex
        #expect(caseIdx >= 0)
        #expect(caseIdx < Finite.Ordinal<5>.caseCount)
        #expect(caseIdx == index)
    }

    @Test(arguments: [0, 1, 2, 3, 4])
    func `init __unchecked creates correct value`(index: Int) {
        let ordinal = Finite.Ordinal<5>(__unchecked: (), index)
        #expect(ordinal.rawValue == index)
        #expect(ordinal.caseIndex == index)
    }

    @Test(arguments: [0, 1, 2, 3, 4])
    func `caseIndex roundtrip`(index: Int) {
        let ordinal = Finite.Ordinal<5>(__unchecked: (), index)
        let caseIdx = ordinal.caseIndex
        let reconstructed = Finite.Ordinal<5>(__unchecked: (), caseIdx)
        #expect(reconstructed == ordinal)
    }

    @Test
    func `allCases returns Enumeration`() {
        let allCases = Finite.Ordinal<5>.allCases
        #expect(allCases.count == Finite.Ordinal<5>.caseCount)
    }

    @Test(arguments: [0, 1, 2])
    func `failable init returns value for valid index`(index: Int) {
        let ordinal = Finite.Ordinal<3>(index)
        #expect(ordinal != nil)
        #expect(ordinal?.rawValue == index)
    }

    @Test(arguments: [-1, 3, 10, 100])
    func `failable init returns nil for invalid index`(index: Int) {
        let invalid = Finite.Ordinal<3>(index)
        #expect(invalid == nil)
    }
}

// MARK: - Enumerable with Ordinal

@Suite
struct `Enumerable - Ordinal Tests` {
    @Test
    func `Ordinal conforms to Enumerable`() {
        let ordinal: Finite.Ordinal<5> = Finite.Ordinal(2)!
        #expect(ordinal.caseIndex == 2)
        #expect(Finite.Ordinal<5>.caseCount == 5)
    }

    @Test(arguments: [0, 1, 2, 3, 4])
    func `Ordinal allCases iteration`(expectedIndex: Int) {
        let allCases = Array(Finite.Ordinal<5>.allCases)
        #expect(allCases[expectedIndex].rawValue == expectedIndex)
    }

    @Test
    func `Ordinal Enumeration is RandomAccessCollection`() {
        let enumeration = Finite.Ordinal<10>.allCases
        #expect(enumeration.count == 10)
        #expect(enumeration.startIndex == 0)
        #expect(enumeration.endIndex == 10)
    }
}
