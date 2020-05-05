import Foundation
import XCTest
@testable import MaxMindDBReader

class MaxMindDecoderAnyTest: XCTestCase {

  private let bigEndianDecoder    = MaxMindDecoder(inputEndianness: .big)
  private let littleEndianDecoder = MaxMindDecoder(inputEndianness: .little)

  func testDecode_any_asString() {
    let string28BytesLong = ControlByte(bytes: Data([0b0101_1100]))!
    let expectedString    = "Hello World Hello World test"
    let decoded           = bigEndianDecoder.decode(
      expectedString.data(using: .utf8)!,
      as: string28BytesLong
    )
    XCTAssertEqual(expectedString, decoded as? String)
  }

  func testDecode_any_asBytes() {
    let bytes5BytesLong = ControlByte(bytes: Data([0b1000_0101]))!
    let expectedBytes   = Data(repeating: 0b1111_1111, count: 5)
    let decoded         = bigEndianDecoder.decode(expectedBytes, as: bytes5BytesLong)
    XCTAssertEqual(expectedBytes, decoded as? Data)
  }

  func testDecode_any_asUInt16() {
    let uInt16_1ByteLong = ControlByte(bytes: Data([0b1010_0001]))!
    let encoded          = Data([0b0111_1011])
    let decoded          = bigEndianDecoder.decode(encoded, as: uInt16_1ByteLong)
    XCTAssertEqual(UInt16(123), decoded as? UInt16)
  }

  func testDecode_any_asUInt32() {
    let uInt32_1ByteLong = ControlByte(bytes: Data([0b1100_0001]))!
    let encoded          = Data([0b0111_1011])
    let decoded          = bigEndianDecoder.decode(encoded, as: uInt32_1ByteLong)
    XCTAssertEqual(UInt32(123), decoded as? UInt32)
  }

  func testDecode_any_asUInt64() {
    let uInt64_1ByteLong = ControlByte(bytes: Data([0b0000_0001, 0b0000_0010]))!
    let encoded          = Data([0b0111_1011])
    let decoded          = bigEndianDecoder.decode(encoded, as: uInt64_1ByteLong)
    XCTAssertEqual(UInt64(123), decoded as? UInt64)
  }

  func testDecode_any_asInt32() {
    let int32_1ByteLong = ControlByte(bytes: Data([0b0000_0001, 0b0000_0001]))!
    let encoded         = Data([0b1000_0100])
    let decoded          = bigEndianDecoder.decode(encoded, as: int32_1ByteLong)
    XCTAssertEqual(Int32(-124), decoded as? Int32)
  }

  func testDecode_any_asBool() {
    let bool_1ByteLong = ControlByte(bytes: Data([0b0000_0001, 0b0000_0111]))!
    let encoded        = Data([])
    let decoded          = bigEndianDecoder.decode(encoded, as: bool_1ByteLong)
    XCTAssertEqual(true, decoded as? Bool)
  }

}
