import Foundation
import XCTest
import TestResources
@testable import Decoder

class FunctionResolveTypeTest: XCTestCase {

  private let representationBaseMap: [DataType: Data] = [
    DataType.pointer: Data([0b0010_0000]),
    DataType.utf8String: Data([0b0100_0000]),
    DataType.double: Data([0b0110_0000]),
    DataType.bytes: Data([0b1000_0000]),
    DataType.uInt16: Data([0b1010_0000]),
    DataType.uInt32: Data([0b1100_0000]),
    DataType.map: Data([0b1110_0000]),
    DataType.int32: Data([0b0000_0000, 0b0000_0001]),
    DataType.uInt64: Data([0b0000_0000, 0b0000_0010]),
    DataType.uInt128: Data([0b0000_0000, 0b0000_0011]),
    DataType.array: Data([0b0000_0000, 0b0000_0100]),
    DataType.dataCacheContainer: Data([0b0000_0000, 0b0000_0101]),
    DataType.endMarker: Data([0b0000_0000, 0b0000_0110]),
    DataType.boolean: Data([0b0000_0000, 0b0000_0111]),
    DataType.float: Data([0b0000_0000, 0b0000_1000])
  ]

  func testResolveType() {
    for (expectedType, bytes) in representationBaseMap {
      for bitMaskToApply in UInt8(0b0000_0000)...UInt8(0b0001_1111) {
        let restOfBytes     = bytes.subdata(in: Range(uncheckedBounds: (lower: 1, upper: bytes.endIndex)))
        let variedFirstByte = bytes[0] | bitMaskToApply
        let input           = Data([variedFirstByte]) + restOfBytes
        guard let bigEndianResolvedType = resolveType(bytes: input, sourceEndianness: .big) else {
          XCTFail("Should have been able to resolve a DataType for input \(input as NSData)")
          continue
        }
        XCTAssertEqual(
          expectedType,
          bigEndianResolvedType,
          "Expected to resolve \(expectedType), but got \(bigEndianResolvedType) for input \(input as NSData)"
        )
        let littleEndianInput = Data(input.reversed())
        guard let littleEndianResolvedType = resolveType(bytes: littleEndianInput, sourceEndianness: .little) else {
          XCTFail("Should have been able to resolve a DataType for input \(input as NSData)")
          continue
        }
        XCTAssertEqual(
          expectedType,
          littleEndianResolvedType,
          "Expected to resolve \(expectedType), but got \(littleEndianResolvedType) for input \(input as NSData)"
        )
      }
    }
  }

  func testResolveType_returnsNilForExtendedTypeWithoutSecondByte() {
    for byte in UInt8(0b0000_0000)...UInt8(0b0001_1111) {
      let input = Data([byte])
      XCTAssertNil(
        resolveType(bytes: input, sourceEndianness: .big),
        "Should have returned nil for input : \(input as NSData)"
      )
      XCTAssertNil(
        resolveType(bytes: input, sourceEndianness: .little),
        "Should have returned nil for input : \(input as NSData)"
      )
    }
  }

}
