import Foundation
import XCTest
@testable import MaxMindDecoder

class MaxMindDecoderNumericTest: XCTestCase {

  private let bigEndianDecoder    = MaxMindDecoder(inputEndianness: .big)
  private let littleEndianDecoder = MaxMindDecoder(inputEndianness: .little)

  func testDecode_uInt16() {
    for (expected, input) in testSpecs_uInt16 {
      assertDecodedValue(expected, bigEndianDecoder.decode, data: input)
    }
    for (expected, input) in testSpecs_uInt16 {
      assertDecodedValue(
        expected,
        littleEndianDecoder.decode,
        data: Data(input.reversed())
      )
    }
  }

  func testDecode_uInt32() {
    for (expected, input) in testSpecs_uInt32 {
      assertDecodedValue(expected, bigEndianDecoder.decode, data: input)
    }
    for (expected, input) in testSpecs_uInt32 {
      assertDecodedValue(
        expected,
        littleEndianDecoder.decode,
        data: Data(input.reversed())
      )
    }
  }

  func testDecode_uInt64() {
    for (expected, input) in testSpecs_uInt64 {
      assertDecodedValue(expected, bigEndianDecoder.decode, data: input)
    }
    for (expected, input) in testSpecs_uInt64 {
      assertDecodedValue(
        expected,
        littleEndianDecoder.decode,
        data: Data(input.reversed())
      )
    }
  }

  func testDecode_int32() {
    for (expected, input) in testSpecs_int32 {
      assertDecodedValue(expected, bigEndianDecoder.decode, data: input)
    }
    for (expected, input) in testSpecs_int32 {
      assertDecodedValue(
        expected,
        littleEndianDecoder.decode,
        data: Data(input.reversed())
      )
    }
  }
}

fileprivate typealias TestSpec<T> = (expected: T, input: Data)

fileprivate let testSpecs_uInt16: [TestSpec<UInt16>] = [
  (expected: 0, input: Data()),
  (expected: 0, input: Data(count: 1)),
  (expected: 0, input: Data(count: 2)),
  (expected: 0, input: Data(count: 3)),
  (expected: 0, input: Data(count: 4)),
  (expected: 0, input: Data(count: 5)),
  (expected: 255, input: Data([0b1111_1111])),
  (expected: 255, input: Data(count: 1) + Data([0b1111_1111])),
  (expected: 14200, input: Data([0b0011_0111, 0b0111_1000])),
  (expected: 14200, input: Data(count: 14) + Data([0b0011_0111, 0b0111_1000]))
]

fileprivate let testSpecs_uInt32: [TestSpec<UInt32>] = [
  (expected: 0, input: Data()),
  (expected: 0, input: Data(count: 1)),
  (expected: 0, input: Data(count: 2)),
  (expected: 0, input: Data(count: 3)),
  (expected: 0, input: Data(count: 4)),
  (expected: 0, input: Data(count: 5)),
  (expected: 4294967295, input: Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])),
  (expected: 4294967295, input: Data(count: 1) + Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])),
  (expected: 14200, input: Data([0b0011_0111, 0b0111_1000])),
  (expected: 14200, input: Data(count: 14) + Data([0b0011_0111, 0b0111_1000])),
  (expected: 16702650, input: Data([0xFE, 0xDC, 0xBA])),
  (expected: 16702650, input: Data(count: 14) + Data([0xFE, 0xDC, 0xBA]))
]

fileprivate let testSpecs_int32: [TestSpec<Int32>] = [
  (expected: 0, input: Data()),
  (expected: 0, input: Data(count: 1)),
  (expected: 0, input: Data(count: 2)),
  (expected: 0, input: Data(count: 3)),
  (expected: 0, input: Data(count: 4)),
  (expected: 0, input: Data(count: 5)),
  (expected: 127, input: Data([0b0111_1111])),
  (expected: -127, input: Data([0b1111_1111, 0b1111_1111, 0b1000_0001])),
  (expected: 32767, input: Data([0b0111_1111, 0b1111_1111])),
  (expected: -32767, input: Data([0b1111_1111, 0b1000_0000, 0b0000_0001])),
  (expected: -2147483647, input: Data([0x80, 0x00, 0x00, 0x01])),
  (expected: 2147483647, input: Data([0x7F, 0xFF, 0xFF, 0xFF])),
  (expected: 2147483647, input: Data(count: 1) + Data([0x00, 0xFF, 0xFF, 0xFF, 0x7F, 0xFF, 0xFF, 0xFF])),
  (expected: 14200, input: Data([0b0011_0111, 0b0111_1000])),
  (expected: 14200, input: Data(count: 14) + Data([0b0011_0111, 0b0111_1000])),
  (expected: -14200, input: Data([0b1111_1111, 0b1100_1000, 0b1000_1000])),
  (expected: 16702650, input: Data([0x00, 0xFE, 0xDC, 0xBA])),
  (expected: 16702650, input: Data(count: 14) + Data([0x00, 0xFE, 0xDC, 0xBA]))
]

fileprivate let testSpecs_uInt64: [TestSpec<UInt64>] = [
  (expected: 0, input: Data()),
  (expected: 0, input: Data(count: 1)),
  (expected: 0, input: Data(count: 2)),
  (expected: 0, input: Data(count: 3)),
  (expected: 0, input: Data(count: 4)),
  (expected: 0, input: Data(count: 5)),
  (expected: 255, input: Data([0b1111_1111])),
  (expected: 255, input: Data(count: 1) + Data([0b1111_1111])),
  (expected: 14200, input: Data([0b0011_0111, 0b0111_1000])),
  (expected: 14200, input: Data(count: 14) + Data([0b0011_0111, 0b0111_1000])),
  (expected: 16702650, input: Data([0xFE, 0xDC, 0xBA])),
  (expected: 16702650, input: Data(count: 14) + Data([0xFE, 0xDC, 0xBA])),
  (expected: 280223976814164, input: Data([0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54])),
  (expected: 280223976814164, input: Data(count: 14) + Data([0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54]))
]

fileprivate func assertDecodedValue<T>(
  _ expected: T,
  _ decode: (Data) -> T,
  data: Data,
  file: StaticString = #file,
  line: UInt = #line
) where T: Equatable {
  XCTAssertEqual(expected, decode(data), file: file, line: line)
}
