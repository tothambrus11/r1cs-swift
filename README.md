# R1CS Swift

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A Swift library for working with R1CS (Rank-1 Constraint Systems) - a fundamental building block for zero-knowledge proofs and constraint-based cryptographic protocols.

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

// Add wires (variables)
let x = r1cs.addWire(labelId: LabelID(rawValue: 1))  // Input wire
let y = r1cs.addWire(labelId: LabelID(rawValue: 2))  // Input wire  
let z = r1cs.addWire(labelId: LabelID(rawValue: 3))  // Output wire

// Create linear combinations
var lc_x = LinearCombination()
lc_x.addTerm(coefficient: BigUInt(1), wire: x)

var lc_y = LinearCombination()  
lc_y.addTerm(coefficient: BigUInt(1), wire: y)

var lc_z = LinearCombination()
lc_z.addTerm(coefficient: BigUInt(1), wire: z)

// Add constraint: x × y = z
let constraint = R1CSConstraint(a: lc_x, b: lc_y, c: lc_z)
r1cs.addConstraint(constraint)

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
let constantWire = R1CS.unitWire  // Always represents 1
let customWire = WireID(rawValue: 42)
```

### `LinearCombination`
Represents expressions like `3×w₁ + 5×w₂ + 7`:

```swift
var lc = LinearCombination()
lc.addTerm(coefficient: BigUInt(3), wire: wire1)
lc.addTerm(coefficient: BigUInt(5), wire: wire2)
lc.addConstant(BigUInt(7))
```

### `R1CSConstraint`
A single constraint of the form A × B = C:

```swift
let constraint = R1CSConstraint(a: leftSide, b: rightSide, c: result)
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
var a = LinearCombination()
a.addTerm(coefficient: BigUInt(2), wire: x)
a.addTerm(coefficient: BigUInt(3), wire: y)

var b = LinearCombination()
b.addTerm(coefficient: BigUInt(1), wire: x)
b.addConstant(fieldPrime - BigUInt(1))  // -1 in field arithmetic

var c = LinearCombination()
c.addTerm(coefficient: BigUInt(1), wire: z)

let complexConstraint = R1CSConstraint(a: a, b: b, c: c)
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

let x = r1cs.addWire(labelId: LabelID(rawValue: 1))
let y = r1cs.addWire(labelId: LabelID(rawValue: 2))

// x × x = y
var lc_x = LinearCombination()
lc_x.addTerm(coefficient: BigUInt(1), wire: x)

var lc_y = LinearCombination()  
lc_y.addTerm(coefficient: BigUInt(1), wire: y)

r1cs.addConstraint(R1CSConstraint(a: lc_x, b: lc_x, c: lc_y))
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