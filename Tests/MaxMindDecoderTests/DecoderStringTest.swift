import Foundation
import XCTest
@testable import MaxMindDecoder

class DecoderStringTest: XCTestCase {
  /// TODO: though MaxMindDB is "big endian" as per the docs, it'd be nice to prepare it for little endian utf-8
  private let decoder = Decoder(inputEndianness: .big)

  func testDecodeAsString() {
    let testStrings = [
      "some test string",
      "another test string",
      "test"
    ]
    for (input, expected) in testStrings.map({ ($0.data(using: .utf8)!, $0) }) {
      XCTAssertEqual(OutputData.utf8String(expected), decoder.decodeAsString(input))
    }
  }
}
