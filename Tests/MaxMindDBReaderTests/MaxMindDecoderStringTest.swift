import Foundation
import XCTest
@testable import MaxMindDBReader

class MaxMindDecoderStringTest: XCTestCase {
  /// TODO: though MaxMindDB is "big endian" as per the docs, it'd be nice to prepare it for little endian utf-8
  private let decoder = MaxMindDecoder(inputEndianness: .big)

  func testDecode_string() {
    let testStrings = [
      "some test string",
      "another test string",
      "test"
    ]
    for (input, expected) in testStrings.map({ ($0.data(using: .utf8), $0) }) {
      XCTAssertEqual(expected, decoder.decode(input!))
    }
  }
}
