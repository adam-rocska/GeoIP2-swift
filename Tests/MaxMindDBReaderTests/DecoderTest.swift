import Foundation
import XCTest
@testable import MaxMindDBReader

fileprivate typealias TestSpec<T> = (expected: T, input: Data)

fileprivate let testSpecs: [TestSpec<UInt16>] = [
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

class DecoderTest: XCTestCase {

  private let bigEndianDecoder    = Decoder(inputEndianness: .big)
  private let littleEndianDecoder = Decoder(inputEndianness: .little)

  func testDecode() {
    for (expected, input) in testSpecs {
      assertDecodedValue(expected, bigEndianDecoder.decode, data: input)
    }
    for (expected, input) in testSpecs {
      assertDecodedValue(
        expected,
        littleEndianDecoder.decode,
        data: Data(input.reversed())
      )
    }
  }
}

fileprivate func assertDecodedValue<T>(
  _ expected: T,
  _ decode: (Data) -> T,
  data: Data,
  file: StaticString = #file,
  line: UInt = #line
) where T: Equatable {
  XCTAssertEqual(expected, decode(data), file: file, line: line)
}
