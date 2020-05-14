import Foundation
import XCTest
@testable import MaxMindDecoder

class MaxMindDecoderPointerTest: XCTestCase {

  // TODO : Little endian decoding also deserves coverage
  private let bigEndianDecoder = MaxMindDecoder(inputEndianness: .big)

  func testDecode_pointerSize1() {
    XCTAssertEqual(
      MaxMindPointer(1),
      bigEndianDecoder.decode(Data([0b0000_0001]), strayBits: 0) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(1793),
      bigEndianDecoder.decode(Data([0b0000_0001]), strayBits: 0b0000_0111) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(1993),
      bigEndianDecoder.decode(Data([0b1100_1001]), strayBits: 0b0000_0111) as MaxMindPointer
    )
  }

  func testDecode_pointerSize2() {
    XCTAssertEqual(
      MaxMindPointer(2049),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0001]),
        strayBits: 0
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(2304),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000]),
        strayBits: 0
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(460801),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(461056),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000]),
        strayBits: 0b0000_0111
      ) as MaxMindPointer
    )
  }

  func testDecode_pointerSize3() {
    XCTAssertEqual(
      MaxMindPointer(526337),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(591872),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000]),
        strayBits: 0
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(117966849),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(118032384),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000]),
        strayBits: 0b0000_0111
      ) as MaxMindPointer
    )
  }

  func testDecode_pointerSize4() {
    XCTAssertEqual(
      MaxMindPointer(1),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(16777216),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000, 0b0000_0000]),
        strayBits: 0
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(1),
      bigEndianDecoder.decode(
        Data([0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0001]),
        strayBits: 0b0000_0111
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(16777216),
      bigEndianDecoder.decode(
        Data([0b0000_0001, 0b0000_0000, 0b0000_0000, 0b0000_0000]),
        strayBits: 0b0000_0111
      ) as MaxMindPointer
    )
    XCTAssertEqual(
      MaxMindPointer(4294967295),
      bigEndianDecoder.decode(
        Data([0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111]),
        strayBits: 0b0000_0111
      ) as MaxMindPointer
    )
  }

}
