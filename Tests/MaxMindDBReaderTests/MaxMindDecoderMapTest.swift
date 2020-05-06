import Foundation
import XCTest
@testable import MaxMindDBReader

class MaxMindDecoderMapTest: XCTestCase {

  private let bigEndianDecoder = MaxMindDecoder(inputEndianness: .big)

  func assertMetadataEquality(
    _ expected: [String: Any],
    _ actual: [String: Any],

    file: StaticString = #file,
    line: UInt = #line
  ) {
    for (key, _) in expected {
      XCTAssert(
        actual.keys.contains(key),
        "Parsed binary dictionary should have had an entry with key \"\(key)\"",
        file: file,
        line: line
      )
    }

    XCTAssertEqual(
      expected["record_size"] as? UInt16,
      actual["record_size"] as? UInt16,
      "record_size: \(expected["record_size"] ?? "nil") ≠ \(actual["record_size"] ?? "nil")",
      file: file,
      line: line
    )
    XCTAssertEqual(
      expected["languages"] as? [String],
      actual["languages"] as? [String],
      "languages: \(expected["languages"] ?? "nil") ≠ \(actual["languages"] ?? "nil")",
      file: file,
      line: line
    )
    XCTAssertEqual(
      expected["database_type"] as? String,
      actual["database_type"] as? String,
      "database_type: \(expected["database_type"] ?? "nil") ≠ \(actual["database_type"] ?? "nil")",
      file: file,
      line: line
    )
    XCTAssertEqual(
      expected["ip_version"] as? UInt16,
      actual["ip_version"] as? UInt16,
      "ip_version: \(expected["ip_version"] ?? "nil") ≠ \(actual["ip_version"] ?? "nil")",
      file: file,
      line: line
    )
    XCTAssertEqual(
      expected["build_epoch"] as? UInt64,
      actual["build_epoch"] as? UInt64,
      "build_epoch: \(expected["build_epoch"] ?? "nil") ≠ \(actual["build_epoch"] ?? "nil")",
      file: file,
      line: line
    )
    XCTAssertEqual(
      expected["node_count"] as? UInt32,
      actual["node_count"] as? UInt32,
      "node_count: \(expected["node_count"] ?? "nil") ≠ \(actual["node_count"] ?? "nil")",
      file: file,
      line: line
    )
    XCTAssertEqual(
      expected["binary_format_minor_version"] as? UInt16,
      actual["binary_format_minor_version"] as? UInt16,
      "binary_format_minor_version: \(expected["binary_format_minor_version"] ?? "nil") ≠ \(actual["binary_format_minor_version"] ?? "nil")",
      file: file,
      line: line
    )
    XCTAssertEqual(
      expected["description"] as? [String: String],
      actual["description"] as? [String: String],
      "description: \(expected["description"] ?? "nil") ≠ \(actual["description"] ?? "nil")",
      file: file,
      line: line
    )
    XCTAssertEqual(
      expected["binary_format_major_version"] as? UInt16,
      actual["binary_format_major_version"] as? UInt16,
      "binary_format_major_version: \(expected["binary_format_major_version"] ?? "nil") ≠ \(actual["binary_format_major_version"] ?? "nil")",
      file: file,
      line: line
    )
  }

  func testDecode_dataToDictionary() {
    let actualMaxMindMetaDataDictionary: [String: Any] = bigEndianDecoder.decode(maxMindMetaData, size: 9)
    assertMetadataEquality(
      expectedMaxMindMetaDataDictionary,
      actualMaxMindMetaDataDictionary
    )
  }

  func testDecode_iteratorToDictionary() {
    guard let iterator = MaxMindIterator(maxMindMetaData) else {
      XCTFail("MaxMind Meta Data is a valid input, yet iterator was not created.")
      return
    }
    let actualMaxMindMetaDataDictionary: [String: Any] = bigEndianDecoder.decode(iterator, size: 9)
    assertMetadataEquality(
      expectedMaxMindMetaDataDictionary,
      actualMaxMindMetaDataDictionary
    )
  }

}

fileprivate let expectedMaxMindMetaDataDictionary: [String: Any] = [
  "record_size": UInt16(24),
  "languages": [
    "de",
    "en",
    "es",
    "fr",
    "ja",
    "pt-BR",
    "ru",
    "zh-CN"
  ],
  "database_type": "GeoLite2-Country",
  "ip_version": UInt16(6),
  "build_epoch": UInt64(1587472614),
  "node_count": UInt32(618459),
  "binary_format_minor_version": UInt16(0),
  "description": [
    "en": "GeoLite2 Country database"
  ],
  "binary_format_major_version": UInt16(2)
]

fileprivate let maxMindMetaData = Data(
  [
    0b01011011, 0b01100010, 0b01101001, 0b01101110,
    0b01100001, 0b01110010, 0b01111001, 0b01011111,
    0b01100110, 0b01101111, 0b01110010, 0b01101101,
    0b01100001, 0b01110100, 0b01011111, 0b01101101,
    0b01100001, 0b01101010, 0b01101111, 0b01110010,
    0b01011111, 0b01110110, 0b01100101, 0b01110010,
    0b01110011, 0b01101001, 0b01101111, 0b01101110,
    0b10100001, 0b00000010, 0b01011011, 0b01100010,
    0b01101001, 0b01101110, 0b01100001, 0b01110010,
    0b01111001, 0b01011111, 0b01100110, 0b01101111,
    0b01110010, 0b01101101, 0b01100001, 0b01110100,
    0b01011111, 0b01101101, 0b01101001, 0b01101110,
    0b01101111, 0b01110010, 0b01011111, 0b01110110,
    0b01100101, 0b01110010, 0b01110011, 0b01101001,
    0b01101111, 0b01101110, 0b10100000, 0b01001011,
    0b01100010, 0b01110101, 0b01101001, 0b01101100,
    0b01100100, 0b01011111, 0b01100101, 0b01110000,
    0b01101111, 0b01100011, 0b01101000, 0b00000100,
    0b00000010, 0b01011110, 0b10011110, 0b11101000,
    0b11100110, 0b01001101, 0b01100100, 0b01100001,
    0b01110100, 0b01100001, 0b01100010, 0b01100001,
    0b01110011, 0b01100101, 0b01011111, 0b01110100,
    0b01111001, 0b01110000, 0b01100101, 0b01010000,
    0b01000111, 0b01100101, 0b01101111, 0b01001100,
    0b01101001, 0b01110100, 0b01100101, 0b00110010,
    0b00101101, 0b01000011, 0b01101111, 0b01110101,
    0b01101110, 0b01110100, 0b01110010, 0b01111001,
    0b01001011, 0b01100100, 0b01100101, 0b01110011,
    0b01100011, 0b01110010, 0b01101001, 0b01110000,
    0b01110100, 0b01101001, 0b01101111, 0b01101110,
    0b11100001, 0b01000010, 0b01100101, 0b01101110,
    0b01011001, 0b01000111, 0b01100101, 0b01101111,
    0b01001100, 0b01101001, 0b01110100, 0b01100101,
    0b00110010, 0b00100000, 0b01000011, 0b01101111,
    0b01110101, 0b01101110, 0b01110100, 0b01110010,
    0b01111001, 0b00100000, 0b01100100, 0b01100001,
    0b01110100, 0b01100001, 0b01100010, 0b01100001,
    0b01110011, 0b01100101, 0b01001010, 0b01101001,
    0b01110000, 0b01011111, 0b01110110, 0b01100101,
    0b01110010, 0b01110011, 0b01101001, 0b01101111,
    0b01101110, 0b10100001, 0b00000110, 0b01001001,
    0b01101100, 0b01100001, 0b01101110, 0b01100111,
    0b01110101, 0b01100001, 0b01100111, 0b01100101,
    0b01110011, 0b00001000, 0b00000100, 0b01000010,
    0b01100100, 0b01100101, 0b01000010, 0b01100101,
    0b01101110, 0b01000010, 0b01100101, 0b01110011,
    0b01000010, 0b01100110, 0b01110010, 0b01000010,
    0b01101010, 0b01100001, 0b01000101, 0b01110000,
    0b01110100, 0b00101101, 0b01000010, 0b01010010,
    0b01000010, 0b01110010, 0b01110101, 0b01000101,
    0b01111010, 0b01101000, 0b00101101, 0b01000011,
    0b01001110, 0b01001010, 0b01101110, 0b01101111,
    0b01100100, 0b01100101, 0b01011111, 0b01100011,
    0b01101111, 0b01110101, 0b01101110, 0b01110100,
    0b11000011, 0b00001001, 0b01101111, 0b11011011,
    0b01001011, 0b01110010, 0b01100101, 0b01100011,
    0b01101111, 0b01110010, 0b01100100, 0b01011111,
    0b01110011, 0b01101001, 0b01111010, 0b01100101,
    0b10100001, 0b00011000
  ]
)
