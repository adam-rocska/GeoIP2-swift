import Foundation
import XCTest
@testable import MaxMindDBReader

fileprivate typealias PayloadSpec = (
  validValueRange: Range<Int>,
  addedValue: Int,
  payloadSizeDefinition: UInt8
)

fileprivate typealias PayloadSizeTestDefinition = (
  expectedPayloadSize: UInt32,
  bytes: Data
)

class ControlByteTest: XCTestCase {

  private static let dataTypes: [DataType] = (1...255).compactMap({ DataType(rawValue: $0) })
  private static let nonExtendedRawValues: [DataType.RawValue] = dataTypes
    .filter({ $0.rawValue <= 7 })
    .map({ $0.rawValue })
  private static let extendedRawValues: [DataType.RawValue] = dataTypes
    .filter({ $0.rawValue > 7 })
    .map({ $0.rawValue })

  private static func createNonExtended(
    _ payloadSpec: PayloadSpec
  ) -> [PayloadSizeTestDefinition] {
    let (validValueRange, addedValue, payloadSizeDefinition) = payloadSpec
    return ControlByteTest
      .nonExtendedRawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + validValueRange.map({ expectedByteCount in
        var byteCountDefinition = expectedByteCount - addedValue
        return (
          expectedPayloadSize: UInt32(expectedByteCount),
          bytes: Data([UInt8(payloadSizeDefinition) | (typeDefinition << 5)]) + Data(
            bytes: &byteCountDefinition,
            count: Int(payloadSizeDefinition & 0b0000_0011)
          )
        )
      })
    }
  }

  private static func createExtended(
    _ payloadSpec: PayloadSpec
  ) -> [PayloadSizeTestDefinition] {
    let (validValueRange, addedValue, payloadSizeDefinition) = payloadSpec
    return ControlByteTest
      .extendedRawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + validValueRange.map({ expectedByteCount in
        var byteCountDefinition = expectedByteCount - addedValue
        return (
          expectedPayloadSize: UInt32(expectedByteCount),
          bytes: Data([UInt8(payloadSizeDefinition), typeDefinition - 7]) + Data(
            bytes: &byteCountDefinition,
            count: Int(payloadSizeDefinition & 0b0000_0011)
          )
        )
      })
    }
  }

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
    for value in ControlByteTest.nonExtendedRawValues {
      for data in (0...4).map({ Data([value &<< 5]) + Data(count: $0) }) {
        XCTAssertEqual(
          DataType(rawValue: value),
          ControlByte(bytes: data)?.type
        )
      }
    }

    for value in ControlByteTest.extendedRawValues {
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
    let nonExtendedRawValues: [PayloadSizeTestDefinition] = ControlByteTest
      .nonExtendedRawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + (0..<29).map({
        (expectedPayloadSize: UInt32($0), bytes: Data([$0 | (typeDefinition << 5)]))
      })
    }
    let extendedRawValues: [PayloadSizeTestDefinition] = ControlByteTest
      .extendedRawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + (0..<29).map({
        (expectedPayloadSize: UInt32($0), bytes: Data([$0, typeDefinition - 7]))
      })
    }

    for (expectedPayloadSize, bytes) in (nonExtendedRawValues + extendedRawValues) {
      XCTAssertEqual(
        expectedPayloadSize,
        ControlByte(bytes: bytes)?.payloadSize
      )
    }
  }

  private static let payloadSpecs: [PayloadSpec] = [
    (
      validValueRange: 29..<285,
      addedValue: 29,
      payloadSizeDefinition: 29
    ),
    (
      validValueRange: 285..<1000,
      addedValue: 285,
      payloadSizeDefinition: 30
    ),
    (
      validValueRange: 25_000..<30_000,
      addedValue: 285,
      payloadSizeDefinition: 30
    ),
    (
      validValueRange: 64_000..<65_821,
      addedValue: 285,
      payloadSizeDefinition: 30
    ),
    (
      validValueRange: 65_821..<66_000,
      addedValue: 65_821,
      payloadSizeDefinition: 31
    ),
    (
      validValueRange: 2_000_000..<2_000_500,
      addedValue: 65_821,
      payloadSizeDefinition: 31
    ),
    (
      validValueRange: 16_843_000..<16_843_037,
      addedValue: 65_821,
      payloadSizeDefinition: 31
    )
  ]

  private static let payloadSizeTestDefinitions: [PayloadSizeTestDefinition] =
    payloadSpecs
      .map({ (extended: createExtended($0), nonExtended: createNonExtended($0)) })
      .reduce([]) { result, testDefinitions in
        result + testDefinitions.extended + testDefinitions.nonExtended
      }

  func testInit_payloadSizeDefinition() {
    for (expectedPayloadSize, bytes) in ControlByteTest.payloadSizeTestDefinitions {
      XCTAssertEqual(
        expectedPayloadSize,
        ControlByte(bytes: bytes)?.payloadSize,
        "Expected a payload size of \(expectedPayloadSize), but instead got \(ControlByte(bytes: bytes)?.payloadSize)"
      )
    }
  }

}
