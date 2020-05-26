import Foundation
import XCTest
@testable import Decoder

class FunctionInterpretUInt32Test: XCTestCase {

  func testInterpretUInt32() {
    let bigEndianTestData: [Data: UInt32] = [
      Data(): 0,
      Data([0x00]): 0,
      Data([0x00, 0x00]): 0,
      Data([0x00, 0x00, 0x00]): 0,
      Data([0x00, 0x00, 0x00, 0x00]): 0,
      Data([0xFF]): 255,
      Data([0x00, 0xFF]): 255,
      Data([0x00, 0x00, 0xFF]): 255,
      Data([0x00, 0x00, 0x00, 0xFF]): 255,
      Data([0xFF, 0xFF]): 65_535,
      Data([0x00, 0xFF, 0xFF]): 65_535,
      Data([0x00, 0x00, 0xFF, 0xFF]): 65_535,
      Data([0xFF, 0xFF, 0xFF]): 16_777_215,
      Data([0x00, 0xFF, 0xFF, 0xFF]): 16_777_215,
      Data([0xFF, 0xFF, 0xFF, 0xFF]): 4_294_967_295
    ]

    for (bytes, expected) in bigEndianTestData {
      guard let bigEndianPayload = interpretUInt32(bytes: bytes, sourceEndianness: .big) else {
        XCTFail("Should have successfully resolved a payload.")
        continue
      }
      guard let littleEndianPayload = interpretUInt32(bytes: Data(bytes.reversed()), sourceEndianness: .little) else {
        XCTFail("Should have successfully resolved a payload.")
        continue
      }
      switch bigEndianPayload {
        case .uInt32(let actual):XCTAssertEqual(expected, actual)
        default: XCTFail("Should have resolved an UInt32 payload")
      }
      switch littleEndianPayload {
        case .uInt32(let actual):XCTAssertEqual(expected, actual)
        default: XCTFail("Should have resolved an UInt32 payload")
      }
    }
  }

}
