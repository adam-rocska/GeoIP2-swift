import Foundation
import XCTest
import TestResources
@testable import Decoder

class FunctionInterpretFloatTest: XCTestCase {

  func testInterpretFloat_returnsNilIfByteCountDoesntMatch() {
    for count in 0...32 {
      if count == MemoryLayout<Float>.size { continue }
      XCTAssertNil(interpretFloat(bytes: Data(repeating: 0xFF, count: count), sourceEndianness: .big))
      XCTAssertNil(interpretFloat(bytes: Data(repeating: 0xFF, count: count), sourceEndianness: .little))
    }
  }

  func testInterpretFloat() {
    let bigEndianTestData: [Data: Float] = [
      Data([0x00, 0x00, 0x00, 0x00]): 0.0,
      Data([0x80, 0x00, 0x00, 0x00]): -0.0,
      Data([0x7F, 0x80, 0x00, 0x00]): Float.infinity,
      Data([0xFF, 0x80, 0x00, 0x00]): -Float.infinity,
      Data([0x40, 0x49, 0x0F, 0xDA]): Float.pi,
      Data([0x3E, 0xAA, 0xAA, 0xAB]): 0.333333343267,
      Data([0x3F, 0x80, 0x00, 0x01]): 1.0000001192,
      Data([0x3F, 0x80, 0x00, 0x00]): 1,
      Data([0x3F, 0x7F, 0xFF, 0xFF]): 0.9999999404,
      Data([0x7F, 0x7F, 0xFF, 0xFF]): Float.greatestFiniteMagnitude,
    ]
    for (bytes, expected) in bigEndianTestData {
      guard let bigEndianPayload = interpretFloat(bytes: bytes, sourceEndianness: .big) else {
        XCTFail("Should have been able to resolve a payload.")
        continue
      }
      guard let littleEndianPayload = interpretFloat(bytes: Data(bytes.reversed()), sourceEndianness: .little) else {
        XCTFail("Should have been able to resolve a payload.")
        continue
      }
      switch bigEndianPayload {
        case .float(let actual): XCTAssertEqual(expected, actual)
        default:                 XCTFail("Should have resolved a float payload.")
      }
      switch littleEndianPayload {
        case .float(let actual): XCTAssertEqual(expected, actual)
        default:                 XCTFail("Should have resolved a float payload.")
      }
    }
  }

}
