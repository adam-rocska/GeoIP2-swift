import Foundation
import XCTest
@testable import MaxMindDecoder

class ControlByteTest: XCTestCase {

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
  }

  override class func setUp() {
    super.setUp()
    precondition(nonExtendedRawValues.count > 0, "nonExtendedRawValues can't be empty.")
    precondition(extendedRawValues.count > 0, "extendedRawValues can't be empty.")
  }

  func testInit_nilIfEmpty() {
    XCTAssertNil(ControlByte(bytes: Data()))
  }

  func testInit_nilIfBiggerThanFive() {
    XCTAssertNil(ControlByte(bytes: Data([0b0100_0000]) + Data(count: 5)))
    XCTAssertNil(ControlByte(bytes: Data([0b0100_0000]) + Data(count: 6)))
    XCTAssertNil(ControlByte(bytes: Data([0b0100_0000]) + Data(count: 7)))
    XCTAssertNil(ControlByte(bytes: Data([0b0100_0000]) + Data(count: 10)))
    XCTAssertNil(ControlByte(bytes: Data([0b0100_0000]) + Data(count: 100)))
    XCTAssertNil(ControlByte(bytes: Data([0b0100_0000]) + Data(count: 10_000)))
  }

  func testInit_dataTypeIdentification() {
    for value in nonExtendedRawValues {
      for data in (0...4).map({ Data([value &<< 5]) + Data(count: $0) }) {
        XCTAssertEqual(
          DataType(rawValue: value),
          ControlByte(bytes: data)?.type
        )
      }
    }

    for value in extendedRawValues {
      for data in (0...3).map({ Data([0b0000_0000, value - 7]) + Data(count: $0) }) {
        XCTAssertEqual(
          DataType(rawValue: value),
          ControlByte(bytes: data)?.type
        )
      }
    }
  }

  func testInit_nilIfDataTypeNotRecognized() {
    XCTAssertNil(ControlByte(bytes: Data([0b0000_1111, 0b0000_1111, 0b0000_0000])))
  }

  func testInit_payloadSizeDefinition_lessThan29() {
    let nonExtended: [ByteSizesTestDefinition] = nonExtendedRawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + (0..<29).map({
        (
          payloadSize: UInt32($0),
          definitionSize: 1,
          input: Data([$0 | (typeDefinition << 5)]))
      })
    }
    let extended: [ByteSizesTestDefinition] = extendedRawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + (0..<29).map({
        (
          payloadSize: UInt32($0),
          definitionSize: 2,
          input: Data([$0, typeDefinition - 7])
        )
      })
    }

    for (payloadSize, definitionSize, input) in (nonExtended + extended) {
      let controlByte = ControlByte(bytes: input)
      XCTAssertEqual(payloadSize, controlByte?.payloadSize)
      XCTAssertEqual(definitionSize, controlByte?.definitionSize)
      XCTAssertEqual(input[..<definitionSize], controlByte?.definition)
    }
  }

  func testInit_payloadSizeDefinition_greaterThan28() {
    for (payloadSize, definitionSize, input) in payloadSizeTestDefinitions {
      let controlByte = ControlByte(bytes: input)
      XCTAssertEqual(
        payloadSize,
        controlByte?.payloadSize,
        "Expected a payload size of \(payloadSize), but instead got \(String(describing: controlByte?.payloadSize))"
      )
      XCTAssertEqual(definitionSize, controlByte?.definitionSize)
      XCTAssertEqual(input[..<definitionSize], controlByte?.definition)
    }
  }

}

/// MARK: Utilities for the effective tests of this unit.

fileprivate let dataTypes: [DataType] = (1...255).compactMap({ DataType(rawValue: $0) })
fileprivate let nonExtendedRawValues: [DataType.RawValue] = dataTypes
  .filter({ $0.rawValue <= 7 })
  .map({ $0.rawValue })
fileprivate let extendedRawValues: [DataType.RawValue] = dataTypes
  .filter({ $0.rawValue > 7 })
  .map({ $0.rawValue })

fileprivate typealias PayloadSpec = (
  validValueRange: Range<Int>,
  addedValue: Int,
  sizeDefinition: UInt8
)

fileprivate typealias ByteSizesTestDefinition = (
  payloadSize: UInt32,
  definitionSize: UInt8,
  input: Data
)

/// TODO: Ugly piece of code, but it works. I could revisit in the future to refactor it.
fileprivate func payloadSizeTestDefiner(
  rawValues: [DataType.RawValue],
  baseDefinitionSize: UInt8,
  createLeadingBytes: @escaping (UInt8, UInt8) -> Data
) -> (PayloadSpec) -> [ByteSizesTestDefinition] {
  return { payloadSpec in
    rawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + payloadSpec.validValueRange.map({ expectedByteCount in
        var byteCountDefinition = expectedByteCount - payloadSpec.addedValue
        let addedSizeDefinition = payloadSpec.sizeDefinition & 0b0000_0011
        return (
          payloadSize: UInt32(expectedByteCount),
          definitionSize: addedSizeDefinition + baseDefinitionSize,
          input: createLeadingBytes(
            payloadSpec.sizeDefinition,
            typeDefinition
          ) + Data(
            bytes: &byteCountDefinition,
            count: Int(addedSizeDefinition)
          )
        )
      })
    }
  }
}

fileprivate let createNonExtended = payloadSizeTestDefiner(
  rawValues: nonExtendedRawValues,
  baseDefinitionSize: 1,
  createLeadingBytes: { Data([UInt8($0) | ($1 << 5)]) }
)

fileprivate let createExtended = payloadSizeTestDefiner(
  rawValues: extendedRawValues,
  baseDefinitionSize: 2,
  createLeadingBytes: { Data([UInt8($0), $1 - 7]) }
)

fileprivate let payloadSpecs: [PayloadSpec] = [
  (validValueRange: 29..<285, addedValue: 29, sizeDefinition: 29),
  (validValueRange: 285..<1000, addedValue: 285, sizeDefinition: 30),
  (validValueRange: 25_000..<30_000, addedValue: 285, sizeDefinition: 30),
  (validValueRange: 64_000..<65_821, addedValue: 285, sizeDefinition: 30),
  (validValueRange: 65_821..<66_000, addedValue: 65_821, sizeDefinition: 31),
  (validValueRange: 2_000_000..<2_000_500, addedValue: 65_821, sizeDefinition: 31),
  (validValueRange: 16_843_000..<16_843_037, addedValue: 65_821, sizeDefinition: 31)
]

fileprivate let payloadSizeTestDefinitions: [ByteSizesTestDefinition] =
  payloadSpecs
    .map({ (extended: createExtended($0), nonExtended: createNonExtended($0)) })
    .reduce([]) { result, testDefinitions in
      result + testDefinitions.extended + testDefinitions.nonExtended
    }