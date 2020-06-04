import Foundation
import XCTest
@testable import Decoder

class FunctionInterpretInt32Test: XCTestCase {

  func testInterpretInt32() {
    let bigEndianTestData: [Data: Int32] = [
      Data(): 0,
      Data([0x00]): 0,
      Data([0x00, 0x00]): 0,
      Data([0x00, 0x00, 0x00]): 0,
      Data([0x00, 0x00, 0x00, 0x00]): 0,
      Data([0xFF]): -1,
      Data([0xFF, 0xFF]): -1,
      Data([0xFF, 0xFF, 0xFF]): -1,
      Data([0xFF, 0xFF, 0xFF, 0xFF]): -1,
      Data([0b1000_0000, 0b0111_1111]): -32641,
      Data([0b1111_1111, 0b1000_0000, 0b0111_1111]): -32641,
      Data([0b1111_1111, 0b1111_1111, 0b1000_0000, 0b0111_1111]): -32641,
      Data([0x00, 0b0111_1111]): 127,
      Data([0x00, 0x00, 0b0111_1111]): 127,
      Data([0x00, 0x00, 0x00, 0b0111_1111]): 127,
      Data([0b0111_1111, 0b1000_0000, 0b0111_1111]): 8355967,
      Data([0x00, 0b0111_1111, 0b1000_0000, 0b0111_1111]): 8355967,
      Data([0b0111_1111, 0b1111_1111, 0b1000_0000, 0b0111_1111]): 2147451007,
    ]

    for (bytes, expected) in bigEndianTestData {
      guard let bigEndianPayload = interpretInt32(bytes: bytes, sourceEndianness: .big) else {
        XCTFail("Should have been able to resolve a payload.")
        continue
      }
      guard let littleEndianPayload = interpretInt32(bytes: Data(bytes.reversed()), sourceEndianness: .little) else {
        XCTFail("Should have been able to resolve a payload.")
        continue
      }
      switch bigEndianPayload {
        case .int32(let actual): XCTAssertEqual(expected, actual)
        default:                 XCTFail("Should have resolved an int32 payload.")
      }
      switch littleEndianPayload {
        case .int32(let actual): XCTAssertEqual(expected, actual)
        default:                 XCTFail("Should have resolved an int32 payload.")
      }
    }
  }

}
