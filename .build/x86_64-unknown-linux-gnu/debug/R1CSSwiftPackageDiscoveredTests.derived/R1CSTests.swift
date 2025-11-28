import XCTest
@testable import R1CSTests

fileprivate extension DebugDemo {
    @available(*, deprecated, message: "Not actually deprecated. Marked as deprecated to allow inclusion of deprecated tests (which test deprecated functionality) without warnings")
    static nonisolated(unsafe) let __allTests__DebugDemo = [
        ("testDebugDemo", testDebugDemo)
    ]
}

fileprivate extension DebugDescriptionTests {
    @available(*, deprecated, message: "Not actually deprecated. Marked as deprecated to allow inclusion of deprecated tests (which test deprecated functionality) without warnings")
    static nonisolated(unsafe) let __allTests__DebugDescriptionTests = [
        ("testConstraintDebugDescription", testConstraintDebugDescription),
        ("testEmptyLinearCombinationDebugDescription", testEmptyLinearCombinationDebugDescription),
        ("testLabelIDDebugDescription", testLabelIDDebugDescription),
        ("testLargeR1CSDebugDescription", testLargeR1CSDebugDescription),
        ("testLinearCombinationDebugDescription", testLinearCombinationDebugDescription),
        ("testR1CSDebugDescription", testR1CSDebugDescription),
        ("testWireIDDebugDescription", testWireIDDebugDescription)
    ]
}

fileprivate extension R1CSTests {
    @available(*, deprecated, message: "Not actually deprecated. Marked as deprecated to allow inclusion of deprecated tests (which test deprecated functionality) without warnings")
    static nonisolated(unsafe) let __allTests__R1CSTests = [
        ("testAddWireUpdatesLabelCount", testAddWireUpdatesLabelCount),
        ("testBinaryFormatStructure", testBinaryFormatStructure),
        ("testBuilderBasics", testBuilderBasics),
        ("testConstantWire", testConstantWire),
        ("testConstraintCreation", testConstraintCreation),
        ("testEmptyConstraintSystem", testEmptyConstraintSystem),
        ("testEmptyLinearCombinations", testEmptyLinearCombinations),
        ("testFieldSizeCalculation", testFieldSizeCalculation),
        ("testHeaderSerialization", testHeaderSerialization),
        ("testLargeFieldSerialization", testLargeFieldSerialization),
        ("testLinearCombination", testLinearCombination),
        ("testLinearCombinationSorting", testLinearCombinationSorting),
        ("testLinearCombinationWithManyTerms", testLinearCombinationWithManyTerms),
        ("testManyConstraints", testManyConstraints),
        ("testManyWires", testManyWires),
        ("testMaxFieldCoefficients", testMaxFieldCoefficients),
        ("testMixedConstraints", testMixedConstraints),
        ("testMultipleWiresWithSameLabel", testMultipleWiresWithSameLabel),
        ("testNextLabelIncrement", testNextLabelIncrement),
        ("testSingleTermLinearCombination", testSingleTermLinearCombination),
        ("testSpecificationExample", testSpecificationExample),
        ("testStrongTypes", testStrongTypes),
        ("testWire2LabelMapSerialization", testWire2LabelMapSerialization),
        ("testWireVisibilityCounts", testWireVisibilityCounts),
        ("testZeroCoefficients", testZeroCoefficients)
    ]
}

fileprivate extension WitnessValidatorIntegrationTests {
    @available(*, deprecated, message: "Not actually deprecated. Marked as deprecated to allow inclusion of deprecated tests (which test deprecated functionality) without warnings")
    static nonisolated(unsafe) let __allTests__WitnessValidatorIntegrationTests = [
        ("testFullValidationFlow", testFullValidationFlow),
        ("testInvalidTriangle", testInvalidTriangle),
        ("testRightTriangleCircuit", testRightTriangleCircuit),
        ("testValidateExampleWitness", testValidateExampleWitness)
    ]
}

fileprivate extension WitnessValidatorTests {
    @available(*, deprecated, message: "Not actually deprecated. Marked as deprecated to allow inclusion of deprecated tests (which test deprecated functionality) without warnings")
    static nonisolated(unsafe) let __allTests__WitnessValidatorTests = [
        ("testConstraintWithConstant", testConstraintWithConstant),
        ("testDebugOutput", testDebugOutput),
        ("testEmptyLinearCombination", testEmptyLinearCombination),
        ("testInvalidWitness", testInvalidWitness),
        ("testLinearCombinationConstraint", testLinearCombinationConstraint),
        ("testModularArithmetic", testModularArithmetic),
        ("testMultipleConstraints", testMultipleConstraints),
        ("testPartialFailure", testPartialFailure),
        ("testSimpleValidWitness", testSimpleValidWitness),
        ("testWithBN254Field", testWithBN254Field),
        ("testWitnessFromJSON", testWitnessFromJSON),
        ("testWitnessFromJSONWithLargeNumbers", testWitnessFromJSONWithLargeNumbers),
        ("testWitnessStructureValidation", testWitnessStructureValidation)
    ]
}
@available(*, deprecated, message: "Not actually deprecated. Marked as deprecated to allow inclusion of deprecated tests (which test deprecated functionality) without warnings")
func __R1CSTests__allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DebugDemo.__allTests__DebugDemo),
        testCase(DebugDescriptionTests.__allTests__DebugDescriptionTests),
        testCase(R1CSTests.__allTests__R1CSTests),
        testCase(WitnessValidatorIntegrationTests.__allTests__WitnessValidatorIntegrationTests),
        testCase(WitnessValidatorTests.__allTests__WitnessValidatorTests)
    ]
}