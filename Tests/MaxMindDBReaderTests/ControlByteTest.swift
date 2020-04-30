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

}
