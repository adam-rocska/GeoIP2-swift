import Foundation
import XCTest
@testable import MaxMindDecoder

class MaxMindDecoderAnyTest: XCTestCase {

  // TODO : little endian cases to be covered
  private let bigEndianDecoder    = MaxMindDecoder(inputEndianness: .big)
  private let littleEndianDecoder = MaxMindDecoder(inputEndianness: .little)

  func testDecode_any_asString_fromData() {
    let string28BytesLong = ControlByte(bytes: Data([0b0101_1100]))!
    let expectedString    = "Hello World Hello World test"
    let decoded           = bigEndianDecoder.decode(
      expectedString.data(using: .utf8)!,
      as: string28BytesLong
    )
    XCTAssertEqual(expectedString, decoded as? String)
  }

  func testDecode_any_asBytes_fromData() {
    let bytes5BytesLong = ControlByte(bytes: Data([0b1000_0101]))!
    let expectedBytes   = Data(repeating: 0b1111_1111, count: 5)
    let decoded         = bigEndianDecoder.decode(expectedBytes, as: bytes5BytesLong)
    XCTAssertEqual(expectedBytes, decoded as? Data)
  }

  func testDecode_any_asUInt16_fromData() {
    let uInt16_1ByteLong = ControlByte(bytes: Data([0b1010_0001]))!
    let encoded          = Data([0b0111_1011])
    let decoded          = bigEndianDecoder.decode(encoded, as: uInt16_1ByteLong)
    XCTAssertEqual(UInt16(123), decoded as? UInt16)
  }

  func testDecode_any_asUInt32_fromData() {
    let uInt32_1ByteLong = ControlByte(bytes: Data([0b1100_0001]))!
    let encoded          = Data([0b0111_1011])
    let decoded          = bigEndianDecoder.decode(encoded, as: uInt32_1ByteLong)
    XCTAssertEqual(UInt32(123), decoded as? UInt32)
  }

  func testDecode_any_asUInt64_fromData() {
    let uInt64_1ByteLong = ControlByte(bytes: Data([0b0000_0001, 0b0000_0010]))!
    let encoded          = Data([0b0111_1011])
    let decoded          = bigEndianDecoder.decode(encoded, as: uInt64_1ByteLong)
    XCTAssertEqual(UInt64(123), decoded as? UInt64)
  }

  func testDecode_any_asInt32_fromData() {
    let int32_1ByteLong = ControlByte(bytes: Data([0b0000_0001, 0b0000_0001]))!
    let encoded         = Data([0b1000_0100])
    let decoded         = bigEndianDecoder.decode(encoded, as: int32_1ByteLong)
    XCTAssertEqual(Int32(-124), decoded as? Int32)
  }

  func testDecode_any_asBool_fromData() {
    let bool_1ByteLong = ControlByte(bytes: Data([0b0000_0001, 0b0000_0111]))!
    let encoded        = Data([])
    let decoded        = bigEndianDecoder.decode(encoded, as: bool_1ByteLong)
    XCTAssertEqual(true, decoded as? Bool)
  }

  func testDecode_any_asArray_fromData() {
    let array                   = ControlByte(bytes: Data([0b00001000, 0b00000100]))!
    let encoded                 = Data(
      [0b01000010, 0b01100100, 0b01100101, 0b01000010,
       0b01100101, 0b01101110, 0b01000010, 0b01100101,
       0b01110011, 0b01000010, 0b01100110, 0b01110010,
       0b01000010, 0b01101010, 0b01100001, 0b01000101,
       0b01110000, 0b01110100, 0b00101101, 0b01000010,
       0b01010010, 0b01000010, 0b01110010, 0b01110101,
       0b01000101, 0b01111010, 0b01101000, 0b00101101,
       0b01000011, 0b01001110
      ]
    )
    let expectedValues          = ["de", "en", "es", "fr", "ja", "pt-BR", "ru", "zh-CN"]
    let decodedViaAny           = bigEndianDecoder.decode(encoded, as: array) as? [Any]
    let decodedViaDirect: [Any] = bigEndianDecoder.decode(encoded, size: Int(array.payloadSize))

    XCTAssertEqual(expectedValues, decodedViaAny as? [String])
    XCTAssertEqual(expectedValues, decodedViaDirect as? [String])
    XCTAssertEqual(decodedViaAny as? [String], decodedViaDirect as? [String])
  }

}
