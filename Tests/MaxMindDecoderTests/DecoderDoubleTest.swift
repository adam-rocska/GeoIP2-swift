import Foundation
import XCTest
@testable import MaxMindDecoder

class DecoderDoubleTest: XCTestCase {

  // TODO : Little Endian case coverage
  private let decoder = Decoder(inputEndianness: .big)

  func testDecodeAsDouble() {
    decoder.decodeAsDouble(bytes: Data())
  }

}
