import Foundation
import XCTest
@testable import MaxMindDecoder

class MaxMindDecoderArrayTest: XCTestCase {

  private let bigEndianDecoder = MaxMindDecoder(inputEndianness: .big)

  func testDecode_array_byData() {
    let rawData      = Data(
      [0b01000010, 0b01100100, 0b01100101, 0b01000010,
       0b01100101, 0b01101110, 0b01000010, 0b01100101,
       0b01110011, 0b01000010, 0b01100110, 0b01110010,
       0b01000010, 0b01101010, 0b01100001, 0b01000101,
       0b01110000, 0b01110100, 0b00101101, 0b01000010,
       0b01010010, 0b01000010, 0b01110010, 0b01110101,
       0b01000101, 0b01111010, 0b01101000, 0b00101101,
       0b01000011, 0b01001110
      ]
    )
    let anies: [Any] = bigEndianDecoder.decode(rawData, size: 8)
    XCTAssertEqual(
      ["de", "en", "es", "fr", "ja", "pt-BR", "ru", "zh-CN"], 
      anies as? [String]
    )
  }

  func testDecode_array_byIterator() {
    let rawData      = Data(
      [0b01000010, 0b01100100, 0b01100101, 0b01000010,
       0b01100101, 0b01101110, 0b01000010, 0b01100101,
       0b01110011, 0b01000010, 0b01100110, 0b01110010,
       0b01000010, 0b01101010, 0b01100001, 0b01000101,
       0b01110000, 0b01110100, 0b00101101, 0b01000010,
       0b01010010, 0b01000010, 0b01110010, 0b01110101,
       0b01000101, 0b01111010, 0b01101000, 0b00101101,
       0b01000011, 0b01001110
      ]
    )
    let iterator     = MaxMindIterator(rawData)!
    let anies: [Any] = bigEndianDecoder.decode(iterator, size: 8)
    XCTAssertEqual(
      ["de", "en", "es", "fr", "ja", "pt-BR", "ru", "zh-CN"],
      anies as? [String]
    )
  }

}
