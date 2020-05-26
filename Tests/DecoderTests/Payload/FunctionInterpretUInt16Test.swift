import Foundation
import XCTest
@testable import Decoder

class FunctionInterpretUInt16Test: XCTestCase {

  func testInterpretUInt16() {
    let bigEndianExpectationMap: [Data: UInt16] = [
      Data(): 0,
      Data([0x00]): 0,
      Data([0xFF]): 255,
      Data([0x00, 0xFF]): 255,
      Data([0xFF, 0xFF]): 65535,
    ]
    for (bigEndianBytes, expected) in bigEndianExpectationMap {
      guard let bigEndianPayload = interpretUInt16(bytes: bigEndianBytes, sourceEndianness: .big) else {
        XCTFail("Should have been able to resolve a payload.")
        continue
      }
      guard let littleEndianPayload = interpretUInt16(
        bytes: Data(bigEndianBytes.reversed()),
        sourceEndianness: .little
      ) else {
        XCTFail("Should have been able to resolve a payload.")
        continue
      }
      switch bigEndianPayload {
        case .uInt16(let actual): XCTAssertEqual(expected, actual)
        default:                  XCTFail("Should have returned an uInt16 payload type.")
      }
      switch littleEndianPayload {
        case .uInt16(let actual): XCTAssertEqual(expected, actual)
        default:                  XCTFail("Should have returned an uInt16 payload type.")
      }
    }
  }

}
