import Foundation
import XCTest
import TestResources
@testable import Decoder

class DataTypeTest: XCTestCase {

  private func assertIsExtendedType(_ type: DataType, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(
      type.isExtended,
      "DataType \(type) should be considered extended.",
      file: file,
      line: line
    )
  }

  private func assertIsNotExtendedType(_ type: DataType, file: StaticString = #file, line: UInt = #line) {
    XCTAssertFalse(
      type.isExtended,
      "DataType \(type) shouldn't be considered extended.",
      file: file,
      line: line
    )
  }

  func testIsExtendedType() {
    assertIsNotExtendedType(DataType.pointer)
    assertIsNotExtendedType(DataType.utf8String)
    assertIsNotExtendedType(DataType.double)
    assertIsNotExtendedType(DataType.bytes)
    assertIsNotExtendedType(DataType.uInt16)
    assertIsNotExtendedType(DataType.uInt32)
    assertIsNotExtendedType(DataType.map)
    assertIsExtendedType(DataType.int32)
    assertIsExtendedType(DataType.uInt64)
    assertIsExtendedType(DataType.uInt128)
    assertIsExtendedType(DataType.array)
    assertIsExtendedType(DataType.dataCacheContainer)
    assertIsExtendedType(DataType.endMarker)
    assertIsExtendedType(DataType.boolean)
    assertIsExtendedType(DataType.float)
  }

}
