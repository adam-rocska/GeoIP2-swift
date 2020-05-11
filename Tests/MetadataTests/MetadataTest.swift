import Foundation
import XCTest
@testable import Metadata
import MaxMindDecoder

class MetadataTest: XCTestCase {

  private func assertCalculatedValues(
    _ metadata: Metadata,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let expectedNodeByteSize: UInt16 = metadata.recordSize / 4
    let expectedSearchTreeSize       = UInt64(metadata.nodeCount * UInt32(expectedNodeByteSize))
    XCTAssertEqual(expectedNodeByteSize, metadata.nodeByteSize, file: file, line: line)
    XCTAssertEqual(expectedSearchTreeSize, metadata.searchTreeSize, file: file, line: line)
  }

  func testInit_nilIfCantCreateIterator() {
    XCTAssertNil(Metadata(Data()))
  }

  func testInit_nilIfCantFetchFirstControlByte() {
    let data = Data([0b0000_1111])
    XCTAssertNil(Metadata(data))
  }

  func testInit_nilIfFirstControlByteIsNotMap() {
    let data = Data([0b0010_1111])
    XCTAssertNil(Metadata(data))
  }

  func testInit_withBinary() {
    guard let metadata = Metadata(binaryMetaData) else {
      XCTFail("Input binary is valid. Should have constructed a proper struct.")
      return
    }

    XCTAssertEqual(618459, metadata.nodeCount)
    XCTAssertEqual(24, metadata.recordSize)
    XCTAssertEqual(6, metadata.ipVersion)
    XCTAssertEqual("GeoLite2-Country", metadata.databaseType)
    XCTAssertEqual(["de", "en", "es", "fr", "ja", "pt-BR", "ru", "zh-CN"], metadata.languages)
    XCTAssertEqual(2, metadata.binaryFormatMajorVersion)
    XCTAssertEqual(0, metadata.binaryFormatMinorVersion)
    XCTAssertEqual(1587472614, metadata.buildEpoch)
    XCTAssertEqual(["en": "GeoLite2 Country database"], metadata.description)
    XCTAssertEqual(6, metadata.nodeByteSize)
    XCTAssertEqual(3710754, metadata.searchTreeSize)
    assertCalculatedValues(metadata)
  }

  func testInit_withIterator() {
    guard let iterator = MaxMindIterator(binaryMetaData) else {
      XCTFail("Input binary is valid. Should have constructed a proper MaxMindIterator.")
      return
    }
    guard let metadata = Metadata(iterator) else {
      XCTFail("Input binary is valid. Should have constructed a proper struct.")
      return
    }

    XCTAssertEqual(618459, metadata.nodeCount)
    XCTAssertEqual(24, metadata.recordSize)
    XCTAssertEqual(6, metadata.ipVersion)
    XCTAssertEqual("GeoLite2-Country", metadata.databaseType)
    XCTAssertEqual(["de", "en", "es", "fr", "ja", "pt-BR", "ru", "zh-CN"], metadata.languages)
    XCTAssertEqual(2, metadata.binaryFormatMajorVersion)
    XCTAssertEqual(0, metadata.binaryFormatMinorVersion)
    XCTAssertEqual(1587472614, metadata.buildEpoch)
    XCTAssertEqual(["en": "GeoLite2 Country database"], metadata.description)
    XCTAssertEqual(6, metadata.nodeByteSize)
    XCTAssertEqual(3710754, metadata.searchTreeSize)
    assertCalculatedValues(metadata)
  }

}

fileprivate let binaryMetaData = Data(
  [
    0b11101001, // control byte
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
