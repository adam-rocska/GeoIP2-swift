import Foundation
import XCTest
@testable import Decoder

class DataTypeTest: XCTestCase {

  func testIsExtendedType() {
    for dataType in DataType.allCases {
      if dataType.rawValue < 8 {
        XCTAssertFalse(dataType.isExtendedType, "\(dataType) is not an extended type.")
      } else {
        XCTAssertTrue(dataType.isExtendedType, "\(dataType) is an extended type.")
      }
    }
  }

  func testInit_fromData_nilIfDataIsEmpty() {
    XCTAssertNil(DataType(Foundation.Data()), "Should be nil when provided Data is totally empty.")
  }

  func testInit_fromData_nilIfExtendedType_butHasNoAdditionalBytesToWorkWith() {
    for byte in UInt8(0b0000_0000)...UInt8(0b0001_1111) {
      let dataType = DataType(Foundation.Data([byte]))
      XCTAssertNil(dataType, "Should be nil if binary is recognized as an extended type, but has no second byte.")
    }
  }

  func testInit_fromData_nilIfTypeNotRecognized() {
    for unrecognizedExtendedTypeByte in 0b0000_1001...0b1111_1111 {
      let bytes = Foundation.Data(
        [
          UInt8(0b0000_0000),
          UInt8(unrecognizedExtendedTypeByte)
        ]
      )
      XCTAssertNil(DataType(bytes), "Should be nil if the provided type is not recognized.")
    }
  }

  func testInit_fromData_nonExtendedTypes() {
    let typeToByteMap: [DataType: UInt8] = [
      DataType.pointer: DataType.pointer.rawValue &<< 5,
      DataType.utf8String: DataType.utf8String.rawValue &<< 5,
      DataType.double: DataType.double.rawValue &<< 5,
      DataType.bytes: DataType.bytes.rawValue &<< 5,
      DataType.uInt16: DataType.uInt16.rawValue &<< 5,
      DataType.uInt32: DataType.uInt32.rawValue &<< 5,
      DataType.map: DataType.map.rawValue &<< 5
    ]
    for (expectedType, byte) in typeToByteMap {
      for variationByte in 0b0000_0000...0b0001_1111 {
        let binary     = Foundation.Data([byte | UInt8(variationByte)])
        let actualType = DataType(binary)
        XCTAssertEqual(expectedType, actualType, "Should be \(expectedType) for binary : \(binary.description)")
      }
    }
  }

  func testInit_fromDaata_extendedType() {
    let typeToByteMap: [DataType: UInt8] = [
      DataType.int32: DataType.int32.rawValue - 7,
      DataType.uInt64: DataType.uInt64.rawValue - 7,
      DataType.uInt128: DataType.uInt128.rawValue - 7,
      DataType.array: DataType.array.rawValue - 7,
      DataType.dataCacheContainer: DataType.dataCacheContainer.rawValue - 7,
      DataType.endMarker: DataType.endMarker.rawValue - 7,
      DataType.boolean: DataType.boolean.rawValue - 7,
      DataType.float: DataType.float.rawValue - 7
    ]
    for (expectedType, byte) in typeToByteMap {
      for variationByte in 0b0000_0000...0b0001_1111 {
        let binary = Foundation.Data([UInt8(variationByte), byte])
        XCTAssertEqual(expectedType, DataType(binary), "Should be \(expectedType) for binary : \(binary.description)")
      }
    }
  }

}
