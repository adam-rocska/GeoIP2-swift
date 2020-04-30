import Foundation
import XCTest
@testable import MaxMindDBReader

class ControlByteTest: XCTestCase {

  private static let dataTypes: [DataType] = (1...255).compactMap({ DataType(rawValue: $0) })
  private static let nonExtendedRawValues: [DataType.RawValue] = dataTypes
    .filter({ $0.rawValue <= 7 })
    .map({ $0.rawValue })
  private static let extendedRawValues: [DataType.RawValue] = dataTypes
    .filter({ $0.rawValue > 7 })
    .map({ $0.rawValue })

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

  fileprivate typealias PayloadSizeTestDefinition = (expectedPayloadSize: UInt32, bytes: Data)

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

  func testInit_payloadSizeDefinition_exactly29() {
    let nonExtendedRawValues: [PayloadSizeTestDefinition] = ControlByteTest
      .nonExtendedRawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + (29..<285).map({
        (
          expectedPayloadSize: UInt32($0),
          bytes: Data([UInt8(29) | (typeDefinition << 5), UInt8($0 - 29)])
        )
      })
    }
    let extendedRawValues: [PayloadSizeTestDefinition] = ControlByteTest
      .extendedRawValues
      .reduce([]) { byteSequence, typeDefinition in
      byteSequence + (29..<285).map({
        (
          expectedPayloadSize: UInt32($0),
          bytes: Data([UInt8(29), typeDefinition - 7, UInt8($0 - 29)])
        )
      })
    }

    for (expectedPayloadSize, bytes) in (nonExtendedRawValues + extendedRawValues) {
      XCTAssertEqual(
        expectedPayloadSize,
        ControlByte(bytes: bytes)?.payloadSize,
        "Expected a payload size of \(expectedPayloadSize), but instead got \(ControlByte(bytes: bytes)?.payloadSize)"
      )
    }
  }

}
