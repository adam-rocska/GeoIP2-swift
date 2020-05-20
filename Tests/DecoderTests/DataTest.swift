import Foundation
import XCTest
@testable import Decoder

class DataTest: XCTestCase {

  func testInit_fromString() {
    let testStrings = [
      "Hello World",
      "Some test string",
      "Another Test STRING"
    ]
    for testString in testStrings {
      XCTAssertEqual(Data(testString.utf8), Data(testString), "Should encode provided string as UTF-8 bytes.")
    }
  }

  func testInit_fromDouble() {
    let bigEndianTestData: [Data: Double] = [
      Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 1,
      Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]): 1.0000000000000002,
      Data([0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02]): 1.0000000000000004,
      Data([0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 2,
      Data([0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): -2,

      Data([0x40, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 3,
      Data([0x40, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 4,
      Data([0x40, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 5,
      Data([0x40, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 6,
      Data([0x40, 0x37, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 23,
      Data([0x3F, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 0.01171875,

      Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]): 5e-324,
      Data([0x00, 0x0F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]): 2.225073858507201e-308,
      Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): 1.390671161567e-309,
      Data([0x7F, 0xEF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]): 1.7976931348623157e+308,

      Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): +0.0,
      Data([0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): -0.0,
      Data([0x7F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): Double.infinity,
      Data([0xFF, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): -Double.infinity,
      // TODO : Important for double assurance, but can't make it work yet.
//    Data([0x7F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]): Double(nan: 0x1, signaling: true),
//    Data([0x7F, 0xF8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]): Double(nan: 0x1, signaling: false),
//    Data([0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]): Double(nan: 0x3ffffffffffff, signaling: false),

      Data([0x40, 0x09, 0x21, 0xfb, 0x54, 0x44, 0x2d, 0x18]): Double.pi,
    ]

    for (expected, input) in bigEndianTestData {
      XCTAssertEqual(
        expected,
        Data(input, targetEndianness: .big),
        "Expected to encode \(input) as expected when target is big endian."
      )
      XCTAssertEqual(
        Data(expected.reversed()),
        Data(input, targetEndianness: .little),
        "Expected to encode \(input) as expected when target is little endian."
      )
    }
  }

  func testInit_fromUInt16() {
    let bigEndianTestData: [Data: UInt16] = [
      Data([0x00, 0x00]): UInt16.min,
      Data([0x00, 0x0F]): 15,
      Data([0x00, 0xFF]): 255,
      Data([0x0F, 0xFF]): 4095,
      Data([0xFF, 0xFF]): UInt16.max
    ]
    for (expected, input) in bigEndianTestData {
      XCTAssertEqual(
        expected,
        Data(input, targetEndianness: .big),
        "Expected to encode \(input) as expected when target is big endian."
      )
      XCTAssertEqual(
        Data(expected.reversed()),
        Data(input, targetEndianness: .little),
        "Expected to encode \(input) as expected when target is little endian."
      )
    }
  }

  func testInit_fromUInt32() {
    let bigEndianTestData: [Data: UInt32] = [
      Data([0x00, 0x00, 0x00, 0x00]): UInt32.min,
      Data([0x00, 0x00, 0x00, 0x0F]): 15,
      Data([0x00, 0x00, 0x00, 0xFF]): 255,
      Data([0x00, 0x00, 0x0F, 0xFF]): 4095,
      Data([0xFF, 0xFF, 0xFF, 0xFF]): UInt32.max
    ]
    for (expected, input) in bigEndianTestData {
      XCTAssertEqual(
        expected,
        Data(input, targetEndianness: .big),
        "Expected to encode \(input) as expected when target is big endian."
      )
      XCTAssertEqual(
        Data(expected.reversed()),
        Data(input, targetEndianness: .little),
        "Expected to encode \(input) as expected when target is little endian."
      )
    }
  }

  func testInit_fromInt32() {
    let bigEndianTestData: [Data: Int32] = [
      Data([0x80, 0x00, 0x00, 0x00]): Int32.min,
      Data([0x00, 0x00, 0x00, 0x0F]): 15,
      Data([0x00, 0x00, 0x00, 0xFF]): 255,
      Data([0x00, 0x00, 0x0F, 0xFF]): 4095,
      Data([0xFF, 0xFF, 0xFF, 0xF1]): -15,
      Data([0xFF, 0xFF, 0xFF, 0x01]): -255,
      Data([0xFF, 0xFF, 0xF0, 0x01]): -4095,
      Data([0xFF, 0xFF, 0xFF, 0xFF]): -1,
      Data([0x00, 0x00, 0x00, 0x00]): 0,
      Data([0x00, 0x00, 0x00, 0x01]): 1,
      Data([0x7F, 0xFF, 0xFF, 0xFF]): Int32.max
    ]
    for (expected, input) in bigEndianTestData {
      XCTAssertEqual(
        expected,
        Data(input, targetEndianness: .big),
        "Expected to encode \(input) as expected when target is big endian."
      )
      XCTAssertEqual(
        Data(expected.reversed()),
        Data(input, targetEndianness: .little),
        "Expected to encode \(input) as expected when target is little endian."
      )
    }
  }

  func testInit_fromUInt64() {
    let bigEndianTestData: [Data: UInt64] = [
      Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]): UInt64.min,
      Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F]): 15,
      Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF]): 255,
      Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0xFF]): 4095,
      Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]): UInt64.max
    ]
    for (expected, input) in bigEndianTestData {
      XCTAssertEqual(
        expected,
        Data(input, targetEndianness: .big),
        "Expected to encode \(input) as expected when target is big endian."
      )
      XCTAssertEqual(
        Data(expected.reversed()),
        Data(input, targetEndianness: .little),
        "Expected to encode \(input) as expected when target is little endian."
      )
    }
  }

  func testInit_fromFloat() {
    let bigEndianTestData: [Data: Float] = [
      Data([0xC0, 0x00, 0x00, 0x00]): -2,
      Data([0x00, 0x00, 0x00, 0x00]): 0.0,
      Data([0x80, 0x00, 0x00, 0x00]): -0.0,
      Data([0x7F, 0x80, 0x00, 0x00]): Float.infinity,
      Data([0xFF, 0x80, 0x00, 0x00]): -Float.infinity,
      // TODO : 40490fdb should be PI and not 40490fda. Is this a bug in Swift, or I'm just dumb & uneducated?
      Data([0x40, 0x49, 0x0F, 0xDA]): Float.pi,
      Data([0x3E, 0xAA, 0xAA, 0xAB]): 0.333333343267,

      Data([0x3F, 0x80, 0x00, 0x01]): 1.0000001192,
      Data([0x3F, 0x80, 0x00, 0x00]): 1,
      Data([0x3F, 0x7F, 0xFF, 0xFF]): 0.9999999404,
      Data([0x7F, 0x7F, 0xFF, 0xFF]): Float.greatestFiniteMagnitude,
      // TODO: Sort out why ("-1.1754944e-38") is not equal to ("1.1754944e-38")
//      Data([0x00, 0x80, 0x00, 0x00]) : -Float.leastNormalMagnitude,

      // TODO: Just as with Double, figure out a way to assert this expected behavior
//      Data([0xFF, 0xC0, 0x00, 0x01]): -Float(nan: 0x01, signaling: false),
//      Data([0xFF, 0x80, 0x00, 0x01]): -Float(nan: 0x01, signaling: true)
    ]

    for (expected, input) in bigEndianTestData {
      XCTAssertEqual(
        expected,
        Data(input, targetEndianness: .big),
        "Expected to encode \(input) as expected when target is big endian."
      )
      XCTAssertEqual(
        Data(expected.reversed()),
        Data(input, targetEndianness: .little),
        "Expected to encode \(input) as expected when target is little endian."
      )
    }
  }

  private func assertPaddingFor<N>(_ Type: N.Type) where N: FixedWidthInteger {
    // TODO : This assertion is incomplete, and primitve for the edge cases when the php scripter fantasy world sends us for example 0b1000_1111  to interpret as a signed int 32.
    let byteVariances: [UInt8] = N.isSigned ? [0x00, 0xFF] : [0x00]
    for count in 0...MemoryLayout<N>.size {
      for byte in byteVariances {
        let bigPadded    = Data(repeating: byte, count: count).padded(for: Type.self, as: .big)
        let littlePadded = Data(repeating: byte, count: count).padded(for: Type.self, as: .little)
        XCTAssertEqual(
          MemoryLayout<N>.size,
          bigPadded.count,
          "The padded Data's length must equal the expected type's byte count."
        )
        XCTAssertEqual(
          MemoryLayout<N>.size,
          littlePadded.count,
          "The padded Data's length must equal the expected type's byte count."
        )
        let expected = Data(repeating: count == 0 ? 0x00 : byte, count: MemoryLayout<N>.size)
        XCTAssertEqual(expected, bigPadded, "Expected \(expected as NSData), got \(bigPadded as NSData)")
        XCTAssertEqual(expected, littlePadded, "Expected \(expected as NSData), got \(bigPadded as NSData)")
      }
    }
  }

  func testPadded() {
    assertPaddingFor(UInt8.self)
    assertPaddingFor(UInt16.self)
    assertPaddingFor(UInt32.self)
    assertPaddingFor(UInt64.self)
    assertPaddingFor(Int32.self)
  }

}
