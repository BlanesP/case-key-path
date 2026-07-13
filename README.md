# CasePathable

A small, educational reimplementation of [Point-Free's swift-case-paths](https://github.com/pointfreeco/swift-case-paths), built from scratch to learn how case paths work.

## What is a case path?

Swift gives you **key paths** for structs, a first-class value that points at a property:

```swift
let nameKeyPath = \User.name   // KeyPath<User, String>
```

Enums have no such thing. A **case path** fills that gap: a first-class value that points at an enum *case*, with two directions, pull the associated value out (**extract**), or build the case back up (**embed**).

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/CasePathable.git", from: "1.0.0"),
]
```

Then add `CasePathable` to your target:

```swift
.target(
    name: "MyTarget",
    dependencies: ["CasePathable"]
)
```

In Xcode, use **File → Add Package Dependencies…** and paste the repository URL.

Requires a Swift 5.9+ toolchain (the `@CasePathable` macro needs macro support). Runs on iOS 13+, macOS 10.15+, tvOS 13+, and watchOS 6+.

## Getting started

Annotate an enum with `@CasePathable`:

```swift
import CasePathable

@CasePathable
enum Payment {
    case cash(Int)
    case card(String)
    case free
    case transfer(iban: String, amount: Int)
}
```

The macro generates everything needed to reference each case with a key-path literal like `\.cash`.

### Extract

Read a case's associated value with the `[case:]` subscript. You get an optional — `nil` when the value isn't that case:

```swift
let payment: Payment = .cash(10)

payment[case: \.cash]   // Optional(10)
payment[case: \.card]   // nil
```

### Embed

Go the other way — call a case path to build the enum:

```swift
let cashPath: CaseKeyPath<Payment, Int> = \.cash
cashPath(10)            // Payment.cash(10)
```

### Check a case

Ask whether a value is a given case, ignoring the associated value:

```swift
payment.is(\.cash)      // true
payment.is(\.free)      // false
```

### Modify

Transform the value inside a case, leaving other cases untouched:

```swift
var p: Payment = .cash(10)
p.modify(\.cash) { $0 * 2 }          // p is now .cash(20)

let discounted = p.modifying(\.cash) { $0 / 2 }   // returns a copy
```

## Working with collections

Case paths shine over a mixed array of cases:

```swift
let payments: [Payment] = [.cash(10), .card("visa"), .cash(20), .free]

payments.compactMap(\.cash)     // [10, 20]  — every cash value
payments.filter(is: \.cash)     // [.cash(10), .cash(20)]
payments.count(is: \.free)      // 1
payments.contains(\.card)       // true
```

Because a case path is a value, you can even collect ones with different associated types into a single array using the type-erased `PartialCaseKeyPath`:

```swift
let cases: [PartialCaseKeyPath<Payment>] = [\.cash, \.card, \.free]
```

## SwiftUI

The `UIExamples` library adds a `Binding` subscript so enum state can drive SwiftUI presentation. Deriving a binding into one case lets a single enum drive several different presentations (a sheet for one case, a popover for another) — something a single `.sheet(item:) { switch … }` can't do:

```swift
@State private var destination: Destination?

.sheet(item: $destination[case: \.edit])   { data in EditView(data) }
.popover(item: $destination[case: \.info]) { data in InfoView(data) }
```

## Main pieces

- `CasePath`: the extract/embed pair.
- `CasePathable`: the protocol an enum conforms to. It requires two things:
  - `associatedtype AllCasePaths` — a type that holds one `CasePath` per case.
  - `static var allCasePaths` — an instance of that type.
- `@CasePathable`: the macro that generates the above for any enum, in two roles:
  - a **member macro** that writes the `AllCasePaths` struct (one computed `CasePath` per case) and `static let allCasePaths`.
  - an **extension macro** that adds the `: CasePathable` conformance.

  It handles cases with no value, one value, multiple values, labels, and access control.
- `CaseKeyPath` / `PartialCaseKeyPath`: key-path-based references to cases.
