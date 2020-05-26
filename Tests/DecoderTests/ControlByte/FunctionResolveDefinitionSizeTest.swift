import Foundation
import XCTest
@testable import Decoder

class FunctionResolveDefinitionSizeTest: XCTestCase {

  func testResolveDefinitionSize_nilIfInputIsEmtpy() {
    for dataType in DataType.allCases {
      XCTAssertNil(
        resolveDefinitionSize(dataType: dataType, bytes: Data(), sourceEndianness: .big),
        "Definition size for dataType \(dataType) should be nil with an empty byte sequence"
      )
      XCTAssertNil(
        resolveDefinitionSize(dataType: dataType, bytes: Data(), sourceEndianness: .little),
        "Definition size for dataType \(dataType) should be nil with an empty byte sequence"
      )
    }
  }

  func testResolveDefinitionSize_1ForPointer() {
    for byte in 0b0000_0000...0b0001_1111 {
      let input = Data([UInt8(byte)])
      XCTAssertEqual(
        1,
        resolveDefinitionSize(
          dataType: .pointer,
          bytes: input,
          sourceEndianness: .big
        ),
        "Expected definition size of 1 for input \(input as NSData) as dataType \(DataType.pointer)"
      )
      XCTAssertEqual(
        1,
        resolveDefinitionSize(
          dataType: .pointer,
          bytes: input,
          sourceEndianness: .little
        ),
        "Expected definition size of 1 for input \(input as NSData) as dataType \(DataType.pointer)"
      )
    }
  }

  func testResolveDefinitionSize() {
    for dataType in DataType.allCases {
      if dataType == .pointer { continue }
      let expectedBaseSize: UInt8 = dataType.isExtended ? 2 : 1
      for baseBits: UInt8 in 0b0000_0000...0b0001_1111 {
        let input = dataType.isExtended
                    ? Data([baseBits, dataType.rawValue])
                    : Data([(dataType.rawValue &<< 5) | baseBits])

        let expectedDefinitionSize        = expectedBaseSize + (baseBits & 0b0000_0011)
        let bigEndianActualDefinitionSize = resolveDefinitionSize(
          dataType: dataType,
          bytes: input,
          sourceEndianness: .big
        )
        XCTAssertEqual(
          expectedDefinitionSize,
          bigEndianActualDefinitionSize,
          "Expected definition size of \(dataType) to be \(expectedDefinitionSize) for input bytes \(input as NSData), but got \(bigEndianActualDefinitionSize)"
        )
        let littleEndianActualDefinitionSize = resolveDefinitionSize(
          dataType: dataType,
          bytes: input,
          sourceEndianness: .little
        )
        XCTAssertEqual(
          expectedDefinitionSize,
          bigEndianActualDefinitionSize,
          "Expected definition size of \(dataType) to be \(expectedDefinitionSize) for input bytes \(input as NSData), but got \(littleEndianActualDefinitionSize)"
        )
      }
    }
  }

}
