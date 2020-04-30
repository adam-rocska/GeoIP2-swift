import Foundation
import XCTest
@testable import MaxMindDBReader

class UInt8Test: XCTestCase {

  func testAreBitsSet() {
    XCTAssertTrue(UInt8(0b0010_0000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertTrue(UInt8(0b0110_0000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertTrue(UInt8(0b1110_0000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertTrue(UInt8(0b1111_0000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertTrue(UInt8(0b1111_1000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertTrue(UInt8(0b1111_1100).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertTrue(UInt8(0b1111_1110).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertTrue(UInt8(0b1111_1111).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertFalse(UInt8(0b0000_0000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertFalse(UInt8(0b0100_0000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertFalse(UInt8(0b1100_0000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertFalse(UInt8(0b1101_0000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertFalse(UInt8(0b1101_1000).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertFalse(UInt8(0b1101_1100).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertFalse(UInt8(0b1101_1110).areBitsSet(bitMask: 0b0010_0000))
    XCTAssertFalse(UInt8(0b1101_1111).areBitsSet(bitMask: 0b0010_0000))

    XCTAssertTrue(UInt8(0b1100_0000).areBitsSet(bitMask: 0b1100_0000))
    XCTAssertTrue(UInt8(0b1110_0000).areBitsSet(bitMask: 0b1100_0000))
    XCTAssertTrue(UInt8(0b1111_0000).areBitsSet(bitMask: 0b1100_0000))
    XCTAssertTrue(UInt8(0b1111_1000).areBitsSet(bitMask: 0b1100_0000))
    XCTAssertTrue(UInt8(0b1111_1100).areBitsSet(bitMask: 0b1100_0000))
    XCTAssertTrue(UInt8(0b1111_1110).areBitsSet(bitMask: 0b1100_0000))
    XCTAssertTrue(UInt8(0b1111_1111).areBitsSet(bitMask: 0b1100_0000))
  }

}
