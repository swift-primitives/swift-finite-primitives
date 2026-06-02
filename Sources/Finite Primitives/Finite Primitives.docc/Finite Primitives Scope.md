# Finite Primitives Scope

The identity surface of `swift-finite-primitives` and what it deliberately excludes.

## Identity

`swift-finite-primitives` provides **finite-enumeration infrastructure** — the
machinery for types with finitely-many indexed inhabitants — together with
**compile-time-capacity-bounded ordinals and indices**.

Two concepts make up that identity:

- *Finite enumeration*: a type with a known, countable number of inhabitants,
  each addressable by an ordinal in `0..<count`. Expressed by
  `Finite.Enumerable`, its zero-allocation `Finite.Enumeration` collection, and
  the compile-time-capacity tag protocol `Finite.Capacity`.
- *Compile-time-capacity bounding*: positions constrained at the type level to
  `[0, N)`. Expressed by the `Finite.Bound<N>` capacity tag, `Ordinal.Finite<N>`,
  and `Index<Element>.Bounded<N>`.

## Core targets

- `Finite Primitive` — the root namespace (`enum Finite`) plus the
  zero-dependency `Finite.Bound<N>` capacity tag.
- `Finite Capacity Primitives` — `Finite.Capacity` and `Finite.Bound`'s capacity
  conformance.
- `Finite Enumerable Primitives` — `Finite.Enumerable`, `Finite.Enumeration`, the
  `CaseIterable` default bridge, and the `Tagged<Finite.Capacity, Ordinal>`
  conformance.
- `Finite Bounded Primitives` — `Ordinal.Finite<N>`, `Index<Element>.Bounded<N>`,
  their arithmetic, and the (language-gated) `Finite.Bounded` protocol.

## Out of scope — extracted integration packages

`Finite.Enumerable` conformances on *foreign* types are NOT part of this
package. Each lives in a standalone recipient-first integration package (per
[PKG-NAME-016], mirroring `swift-cardinal-algebra-primitives`), so the bare
package carries only its foundational dependencies:

- `Comparison` (comparison-primitives) → `swift-comparison-finite-primitives`
- `Interval.Bound` / `Interval.Boundary` / `Interval.Endpoint`
  (interval-primitives) → `swift-interval-finite-primitives`
- `Order.Monotonicity` (order-primitives) → `swift-order-finite-primitives`
- `Numeric.Sign` / `Numeric.Ternary` (numeric-primitives) →
  `swift-numeric-finite-primitives`

Finite only *provides* `Finite.Enumerable`; it does not own those types. Each
bridge depends on `swift-finite-primitives` (for `Finite Enumerable Primitives`)
plus the recipient's home package. Finite's own dependency set therefore stays
minimal: cardinal, ordinal, tagged, index, iterator.

- The ℤ/Nℤ cyclic-group algebra over `Finite.Enumerable` and the
  algebra-classification `Finite.Enumerable` conformances:
  → `swift-finite-algebra-primitives` (the one `finite ⊗ algebra` bridge).

## Evaluation rule

Sub-target additions are evaluated against this scope. If a proposed addition is
OUT of scope, it extracts to a sibling package, not into this one.
