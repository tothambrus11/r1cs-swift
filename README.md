# R1CS Swift

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A Swift library for working with and serializing R1CS (Rank-1 Constraint Systems) - a fundamental building block for zero-knowledge proofs and constraint-based cryptographic protocols.

The library implements the format based on [Iden3's Specification](https://github.com/iden3/r1csfile/blob/master/doc/r1cs_bin_format.md).

## What is R1CS?

R1CS (Rank-1 Constraint System) is a mathematical framework used in zero-knowledge proof systems like zk-SNARKs. It represents computational problems as sets of quadratic constraints over a finite field, where each constraint has the form:

```
(A) × (B) = (C)
```

Where A, B, and C are linear combinations of variables (called "wires" in this library).

## Features

- ✅ **Complete R1CS Implementation**: Build constraint systems incrementally
- ✅ **Binary Serialization**: Compatible with standard R1CS formats
- ✅ **Witness Validation**: Verify that solutions satisfy all constraints
- ✅ **Field Arithmetic**: Support for arbitrary prime fields (with BigInt)
- ✅ **Debug Support**: Comprehensive debug descriptions for debugging circuits
- ✅ **Type Safety**: Strong Swift types for wires, labels, and constraints
- ✅ **Well Tested**: Comprehensive test suite with 50+ test cases

## Installation

### Swift Package Manager

Add this to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/tothambrus11/r1cs-swift.git", from: "1.0.0")
]
```

Then add the library to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "R1CS", package: "r1cs-swift")
    ]
)
```

## Quick Start

```swift
import R1CS
import BigInt

// Create a constraint system over the BN254 field
let bn254Prime = BigUInt("21888242871839275222246405745257275088548364400416034343698204186575808495617")!
var r1cs = R1CS(prime: bn254Prime)

// Add wires (variables) - labels are allocated automatically
let x = r1cs.addWire()  // Input wire
let y = r1cs.addWire()  // Input wire  
let z = r1cs.addWire()  // Output wire

// Create constraint: x × y = z using elegant syntax
r1cs.addConstraint(.init(
    a: .wire(x),           // Linear combination with just wire x
    b: .wire(y),           // Linear combination with just wire y  
    c: .wire(z)            // Linear combination with just wire z
))

// Print the system
print(r1cs.debugDescription)
```

## Core Types

### `R1CS`
The main constraint system builder. Manages wires, labels, and constraints.

```swift
var r1cs = R1CS(prime: fieldPrime)
let wire = r1cs.addWire(labelId: someLabel)
r1cs.addConstraint(constraint)
```

### `WireID`
A unique identifier for variables in the constraint system:

```swift
let constantWire: WireID = .one            // Always represents 1 (shorthand)
let customWire = WireID(rawValue: 42)
```

### `LabelID`
Labels for organizing circuit variables (managed automatically by R1CS):

```swift
// ✅ Let R1CS manage labels automatically
let x = r1cs.addWire()  // Gets next available label

// ✅ Only specify labelId when you need specific label allocation
// (advanced usage - labels come from R1CS methods, not raw construction)
let specificLabel = r1cs.nextLabel()
let y = r1cs.addWire(labelId: specificLabel)
```

### `LinearCombination`
Represents expressions like `3×w₁ + 5×w₂ + 7`. Use concise initializers:

```swift
// ✅ Preferred: Create complete expressions at once
let lc = LinearCombination([
    (BigUInt(3), wire1),
    (BigUInt(5), wire2)
], constant: BigUInt(7))

// ✅ Common patterns using static methods
let singleWire = LinearCombination.wire(x)           // Just x
let constant = LinearCombination.constant(BigUInt(5)) // Just 5
let wireWithCoeff = LinearCombination.term(BigUInt(3), x) // 3×x

// 💡 For simple cases, use shorthands:
let simpleWire: LinearCombination = .wire(x)
let five: LinearCombination = .constant(5)
```

### `R1CSConstraint`  
A single constraint of the form A × B = C. Use shorthand initializers:

```swift
// ✅ Elegant constraint creation
let constraint: R1CSConstraint = .init(
    a: .wire(x),                    // x
    b: .term(BigUInt(2), y),       // 2×y  
    c: .constant(10)               // 10
)
```

## Witness Validation

Validate that a witness (solution) satisfies all constraints:

```swift
// Your witness values (one per wire, starting with wire 0 = 1)
let witness = [
    BigUInt(1),  // wire 0 (constant)
    BigUInt(3),  // wire 1 (x = 3)
    BigUInt(4),  // wire 2 (y = 4) 
    BigUInt(12)  // wire 3 (z = 12)
]

let validator = WitnessValidator(r1cs: r1cs, witness: witness)
let result = validator.validate()

if result.isValid {
    print("✓ All constraints satisfied!")
} else {
    print("✗ Validation failed:")
    for constraint in result.constraintResults where !constraint.isSatisfied {
        print(constraint.errorMessage ?? "Unknown error")
    }
}
```

## Serialization

Export your R1CS to the standard binary format:

```swift
let serializer = R1CSSerializer(r1cs: r1cs)
let binaryData = try serializer.serialize()

// Write to file
try binaryData.write(to: URL(fileURLWithPath: "circuit.r1cs"))
```

## Best Practices

### Preferred Syntax Patterns

```swift
// ✅ Use shorthand initializers and static methods
let x = r1cs.addWire()  // Automatic label allocation
let constraint: R1CSConstraint = .init(
    a: .wire(x),                              // Simple wire
    b: .term(BigUInt(3), y),                 // Coefficient × wire
    c: .constant(42)                         // Just a constant
)

// ✅ Complex linear combinations in one go
let multiTerm = LinearCombination([
    (BigUInt(2), wire1),
    (BigUInt(5), wire2), 
    (BigUInt(1), wire3)
], constant: BigUInt(10))                    // 2×w1 + 5×w2 + w3 + 10

// ✅ Use type inference for cleaner code
r1cs.addConstraint(.init(a: .wire(x), b: .wire(y), c: .wire(z)))

// ✅ Leverage constants like .one for the unit wire
let unitWire: WireID = .one
```

### What to Avoid

```swift
// ❌ Avoid verbose term-by-term construction
var lc = LinearCombination()
lc.addTerm(coefficient: BigUInt(2), wire: wire1)
lc.addTerm(coefficient: BigUInt(5), wire: wire2)
lc.addConstant(BigUInt(10))

// ❌ Unnecessary explicit types when inferred
let constraint = R1CSConstraint(
    a: LinearCombination.wire(x),
    b: LinearCombination.wire(y),
    c: LinearCombination.wire(z)
)
```

## Advanced Usage

### Working with Different Fields

```swift
// Small field for testing
let smallPrime = BigUInt(101)
var testR1CS = R1CS(prime: smallPrime)

// BN254 field (common in zk-SNARKs)
let bn254 = BigUInt("21888242871839275222246405745257275088548364400416034343698204186575808495617")!
var productionR1CS = R1CS(prime: bn254)
```

### Complex Constraints

```swift
// Constraint: (2×x + 3×y) × (x - 1) = z
let complexConstraint: R1CSConstraint = .init(
    a: LinearCombination([                    // 2×x + 3×y
        (BigUInt(2), x),
        (BigUInt(3), y)
    ]),
    b: LinearCombination([                    // x - 1  
        (BigUInt(1), x)
    ], constant: fieldPrime - BigUInt(1)),    // -1 in field arithmetic
    c: .wire(z)                              // z
)

r1cs.addConstraint(complexConstraint)
```

### Loading from JSON Witness

```swift
let witnessJSON = """
[
  "1",
  "3", 
  "4",
  "12"
]
"""

let validator = try WitnessValidator.fromJSON(
    r1cs: r1cs, 
    witnessJSON: witnessJSON
)
let result = validator.validate()
```

## Field Arithmetic

R1CS operates over prime finite fields. All arithmetic is performed modulo the field prime:

- **Addition**: `(a + b) mod p`
- **Subtraction**: `(a - b) mod p` 
- **Multiplication**: `(a × b) mod p`
- **Additive Inverse**: `-a ≡ (p - a) mod p`

The library handles this automatically when working with `BigUInt` coefficients.

## Integration with ZK Proof Systems

This library generates R1CS in the standard format compatible with:

- **circom/snarkjs**: Use the binary output with snarkjs
- **bellman**: Load the R1CS file in Rust
- **libsnark**: Compatible binary format
- **Hylo Language**: Originally extracted from the Hylo compiler

## Examples

### Quadratic Circuit (x² = y)

```swift
var r1cs = R1CS(prime: bn254Prime)

let x = r1cs.addWire()  // Label allocated automatically
let y = r1cs.addWire()  // Label allocated automatically

// x × x = y using elegant shorthand
r1cs.addConstraint(.init(
    a: .wire(x),    // x
    b: .wire(x),    // x  
    c: .wire(y)     // y
))
```

### Range Check (ensure 0 ≤ x ≤ 255)

```swift
// This would typically involve binary decomposition
// and multiple constraints - see advanced circuit design
```

## Testing

Run the test suite:

```bash
swift test
```

The library includes comprehensive tests covering:
- Basic R1CS operations
- Linear combination arithmetic
- Constraint validation
- Serialization/deserialization  
- Witness validation
- Field arithmetic edge cases

## Performance

- **Memory Efficient**: Optimized data structures for large circuits
- **BigInt Integration**: Handles arbitrary precision arithmetic
- **Incremental Building**: Add constraints one at a time
- **Fast Validation**: Efficient witness checking algorithms

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality  
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Originally developed as part of the [Hylo programming language](https://github.com/hylo-lang/hylo)
- Built on [Swift BigInt](https://github.com/attaswift/BigInt) for arbitrary precision arithmetic
- Inspired by the R1CS format used in various zero-knowledge proof systems

## Related Projects

- [Hylo Language](https://github.com/hylo-lang/hylo) - The language this library was extracted from
- [circom](https://github.com/iden3/circom) - Circuit compiler for zk-SNARKs
- [bellman](https://github.com/zkcrypto/bellman) - Rust zk-SNARK library
- [libsnark](https://github.com/scipr-lab/libsnark) - C++ zk-SNARK library
