import Foundation
import XCTest
@testable import MaxMindDecoder

class DecoderPointerTest: XCTestCase {
  // TODO : Little endian decoding also deserves coverage
  private let bigEndianDecoder = Decoder(inputEndianness: .big)

  func testDecodeAsPointerpointerSize1() {
    XCTAssertEqual(
      OutputData.pointer(1),
      bigEndianDecoder.decodeAsPointer(Data([0b0000_0001]), strayBits: 0)
    )
    XCTAssertEqual(
      OutputData.pointer(1793),
      bigEndianDecoder.decodeAsPointer(Data([0b0000_0001]), strayBits: 0b0000_0111)
    )
    XCTAssertEqual(
      OutputData.pointer(1993),
      bigEndianDecoder.decodeAsPointer(Data([0b1100_1001]), strayBits: 0b0000_0111)
    )
  }

  func testDecodeAsPointerpointerSize2() {
    XCTAssertEqual(
      OutputData.pointer(2049),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0000, 0b0000_0001]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(2304),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0001, 0b0000_0000]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(460801),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      )
    )
    XCTAssertEqual(
      OutputData.pointer(461056),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0001, 0b0000_0000]),
        strayBits: 0b0000_0111
      )
    )
  }

  func testDecodeAsPointerpointerSize3() {
    XCTAssertEqual(
      OutputData.pointer(526337),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(591872),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(117966849),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      )
    )
    XCTAssertEqual(
      OutputData.pointer(118032384),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000]),
        strayBits: 0b0000_0111
      )
    )
  }

  func testDecodeAsPointerpointerSize4() {
    XCTAssertEqual(
      OutputData.pointer(1),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(16777216),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000, 0b0000_0000]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(1),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      )
    )
    XCTAssertEqual(
      OutputData.pointer(16777216),
      bigEndianDecoder.decodeAsPointer(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000, 0b0000_0000]),
        strayBits: 0b0000_0111
      )
    )
    XCTAssertEqual(
      OutputData.pointer(4294967295),
      bigEndianDecoder.decodeAsPointer(
        Data([0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111]),
        strayBits: 0b0000_0111
      )
    )
  }

}
