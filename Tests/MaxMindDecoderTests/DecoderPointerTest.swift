import Foundation
import XCTest
@testable import MaxMindDecoder

class DecoderPointerTest: XCTestCase {
  // TODO : Little endian decoding also deserves coverage
  private let bigEndianDecoder = Decoder(inputEndianness: .big)

  func testDecode_pointerSize1() {
    XCTAssertEqual(
      OutputData.pointer(1),
      bigEndianDecoder.decode(Data([0b0000_0001]), strayBits: 0)
    )
    XCTAssertEqual(
      OutputData.pointer(1793),
      bigEndianDecoder.decode(Data([0b0000_0001]), strayBits: 0b0000_0111)
    )
    XCTAssertEqual(
      OutputData.pointer(1993),
      bigEndianDecoder.decode(Data([0b1100_1001]), strayBits: 0b0000_0111)
    )
  }

  func testDecode_pointerSize2() {
    XCTAssertEqual(
      OutputData.pointer(2049),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0001]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(2304),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(460801),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      )
    )
    XCTAssertEqual(
      OutputData.pointer(461056),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000]),
        strayBits: 0b0000_0111
      )
    )
  }

  func testDecode_pointerSize3() {
    XCTAssertEqual(
      OutputData.pointer(526337),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(591872),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(117966849),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      )
    )
    XCTAssertEqual(
      OutputData.pointer(118032384),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000]),
        strayBits: 0b0000_0111
      )
    )
  }

  func testDecode_pointerSize4() {
    XCTAssertEqual(
      OutputData.pointer(1),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(16777216),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000, 0b0000_0000]),
        strayBits: 0
      )
    )
    XCTAssertEqual(
      OutputData.pointer(1),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      )
    )
    XCTAssertEqual(
      OutputData.pointer(16777216),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000, 0b0000_0000]),
        strayBits: 0b0000_0111
      )
    )
    XCTAssertEqual(
      OutputData.pointer(4294967295),
      bigEndianDecoder.decode(
        Data([0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111]),
        strayBits: 0b0000_0111
      )
    )
  }

}
