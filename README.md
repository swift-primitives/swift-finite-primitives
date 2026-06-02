# Finite Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-primitives/swift-finite-primitives/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-finite-primitives/actions/workflows/ci.yml)

Compile-time-bounded finite types: `Ordinal.Finite<N>` — a value provably in `0..<N` — `Index<Element>.Bounded<N>` — a bounds-checked index — and `Finite.Enumerable`, the protocol for types with a known, finite set of cases and a typed `.allCases`.

The bound `N` lives in the type, so an out-of-range value can't be constructed except through a failable initializer that returns `nil`. A `Bounded` index has the same memory layout as a plain `Index` — the safety is in the type system, not in the representation.

---

## Key Features

- **Bounded ordinal** — `Ordinal.Finite<N>` holds a value in `0..<N`. Literal-constructible (`let x: Ordinal.Finite<8> = 3`), with a failable `init?(_:)` that rejects out-of-range integers, a static `count`, and `ordinal` / `successor()` / `predecessor()` / `offset(by:)`.
- **Bounded index** — `Index<Element>.Bounded<N>` is a phantom-typed index narrowed to `0..<N` (it's `Tagged<Element, Ordinal.Finite<N>>`, same size/stride/alignment as a plain `Index`). Narrow with a failable init; widen back losslessly.
- **Finite enumerables** — conform to `Finite.Enumerable` for a static `count` and an `.allCases` `Finite.Enumeration` that is a `RandomAccessCollection`.
- **Capacity** — `Finite.Capacity` expresses a bounded capacity for sizing buffers and collections in the type system.

---

## Quick Start

```swift
import Finite_Primitives

// A value provably in 0..<8:
let three: Ordinal.Finite<8> = 3
Ordinal.Finite<8>.count          // 8
three.ordinal                    // 3

// Construction is failable — an out-of-range value can't sneak in:
Ordinal.Finite<8>(7)             // Optional(7)
Ordinal.Finite<8>(8)             // nil

// Every case, as a RandomAccessCollection:
Ordinal.Finite<5>.allCases.count // 5
```

A bounds-checked index narrows a plain `Index` to a capacity — same layout, checked construction:

```swift
let i: Index<Int> = 5
Index<Int>.Bounded<8>(i)         // Optional — 5 fits in 0..<8

let j: Index<Int> = 9
Index<Int>.Bounded<8>(j)         // nil — out of bounds
```

---

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-finite-primitives.git", branch: "main")
]
```

Add the umbrella product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Finite Primitives", package: "swift-finite-primitives")
    ]
)
```

Or depend on a narrower product (e.g. `Finite Bounded Primitives` for just the bounded types) — see Architecture.

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the corresponding Linux / Windows toolchain).

---

## Architecture

| Product | Contents | When to import |
|---------|----------|----------------|
| `Finite Primitives` | Umbrella — re-exports all of the below | Most consumers |
| `Finite Bounded Primitives` | `Ordinal.Finite<N>` and `Index<Element>.Bounded<N>` | Bounded values and indices |
| `Finite Enumerable Primitives` | `Finite.Enumerable`, `Finite.Enumeration`, and the finite-enumerable conformances | Finite enumerable types + `.allCases` |
| `Finite Capacity Primitives` | `Finite.Capacity` | Bounded capacities |
| `Finite Primitive` | The bare `Finite` namespace enum | Namespace only (rare) |
| `Finite Primitives Test Support` | Re-exports for downstream test targets | Test target only |

---

## Platform Support

| Platform         | CI  | Status       |
|------------------|-----|--------------|
| macOS 26         | Yes | Full support |
| Linux            | Yes | Full support |
| Windows          | Yes | Full support |
| iOS/tvOS/watchOS | —   | Supported    |
| Swift Embedded   | —   | Supported    |

---

## Related Packages

- [`swift-ordinal-primitives`](https://github.com/swift-primitives/swift-ordinal-primitives) — `Ordinal`, which `Ordinal.Finite` bounds.
- [`swift-index-primitives`](https://github.com/swift-primitives/swift-index-primitives) — `Index<T>`, which `.Bounded` narrows.
- [`swift-tagged-primitives`](https://github.com/swift-primitives/swift-tagged-primitives) — `Tagged`, the zero-overhead wrapper behind `Index.Bounded`.
- [`swift-cardinal-primitives`](https://github.com/swift-primitives/swift-cardinal-primitives) — `Cardinal`, the count type behind `Finite.Capacity`.
- [`swift-iterator-primitives`](https://github.com/swift-primitives/swift-iterator-primitives) — `Iterator`, backing the `Finite.Enumeration` collection.

---

## Community

<!-- BEGIN: discussion -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
