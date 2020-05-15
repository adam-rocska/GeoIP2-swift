import Foundation
import XCTest
@testable import MaxMindDecoder

class MaxMindIteratorTest: XCTestCase {

  private let decoder = MaxMindDecoder(inputEndianness: .big)

  func testInit_returnsNilIfDataIsEmpty() {
    XCTAssertNil(MaxMindIterator(Data()))
  }

  func assertNext<T>(
    _ iterator: MaxMindIterator,
    type: DataType,
    payloadSize: UInt32,
    definitionSize: UInt8,
    expectedValue: T,
    decoder decode: (Data) -> T,
    file: StaticString = #file,
    line: UInt = #line
  ) where T: Equatable {
    guard
      let controlByte = iterator.next()
      else {
      XCTFail(
        "Should have returned a control byte of Type:\(type) Payload:\(payloadSize) DefinitionSize:\(definitionSize).",
        file: file,
        line: line
      )
      return
    }

    XCTAssertEqual(type, controlByte.type, file: file, line: line)
    XCTAssertEqual(definitionSize, controlByte.definitionSize, file: file, line: line)
    XCTAssertEqual(payloadSize, controlByte.payloadSize, file: file, line: line)
    let valueBytes = iterator.next(controlByte)

    XCTAssertEqual(expectedValue, decode(valueBytes), file: file, line: line)
  }

  private func assertMaxMindMetaData(_ iterator: MaxMindIterator, of data: Data) {
    let mainMapByte = iterator.next()
    XCTAssertEqual(DataType.map, mainMapByte?.type)
    XCTAssertEqual(1, mainMapByte?.definitionSize)
    XCTAssertEqual(9, mainMapByte?.payloadSize)

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 27,
      definitionSize: 1,
      expectedValue: "binary_format_major_version",
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .uInt16,
      payloadSize: 1,
      definitionSize: 1,
      expectedValue: 2,
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 27,
      definitionSize: 1,
      expectedValue: "binary_format_minor_version",
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .uInt16,
      payloadSize: 0,
      definitionSize: 1,
      expectedValue: 0,
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 11,
      definitionSize: 1,
      expectedValue: "build_epoch",
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .uInt64,
      payloadSize: 4,
      definitionSize: 2,
      expectedValue: UInt64(1587472614),
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 13,
      definitionSize: 1,
      expectedValue: "database_type",
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 16,
      definitionSize: 1,
      expectedValue: "GeoLite2-Country",
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 11,
      definitionSize: 1,
      expectedValue: "description",
      decoder: decoder.decode
    )

    let descriptionMapByte = iterator.next()
    XCTAssertEqual(DataType.map, descriptionMapByte?.type)
    XCTAssertEqual(1, descriptionMapByte?.definitionSize)
    XCTAssertEqual(1, descriptionMapByte?.payloadSize)

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 2,
      definitionSize: 1,
      expectedValue: "en",
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 25,
      definitionSize: 1,
      expectedValue: "GeoLite2 Country database",
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 10,
      definitionSize: 1,
      expectedValue: "ip_version",
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .uInt16,
      payloadSize: 1,
      definitionSize: 1,
      expectedValue: 6,
      decoder: decoder.decode
    )

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 9,
      definitionSize: 1,
      expectedValue: "languages",
      decoder: decoder.decode
    )

    let languagesArrayByte = iterator.next()
    XCTAssertEqual(DataType.array, languagesArrayByte?.type)
    XCTAssertEqual(2, languagesArrayByte?.definitionSize)
    XCTAssertEqual(8, languagesArrayByte?.payloadSize)

    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 2,
      definitionSize: 1,
      expectedValue: "de",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 2,
      definitionSize: 1,
      expectedValue: "en",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 2,
      definitionSize: 1,
      expectedValue: "es",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 2,
      definitionSize: 1,
      expectedValue: "fr",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 2,
      definitionSize: 1,
      expectedValue: "ja",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 5,
      definitionSize: 1,
      expectedValue: "pt-BR",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 2,
      definitionSize: 1,
      expectedValue: "ru",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 5,
      definitionSize: 1,
      expectedValue: "zh-CN",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 10,
      definitionSize: 1,
      expectedValue: "node_count",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .uInt32,
      payloadSize: 3,
      definitionSize: 1,
      expectedValue: 618459,
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .utf8String,
      payloadSize: 11,
      definitionSize: 1,
      expectedValue: "record_size",
      decoder: decoder.decode
    )
    assertNext(
      iterator,
      type: .uInt16,
      payloadSize: 1,
      definitionSize: 1,
      expectedValue: 24,
      decoder: decoder.decode
    )
  }

  func testNext() {
    guard let iterator = MaxMindIterator(maxMindMetaData) else {
      XCTFail("Iterator should have been creatable.")
      return
    }
    assertMaxMindMetaData(iterator, of: maxMindMetaData)
    XCTAssertNil(iterator.next())
    XCTAssertTrue(iterator.isExhausted)
    iterator.rewind()
    XCTAssertFalse(iterator.isExhausted)
    assertMaxMindMetaData(iterator, of: maxMindMetaData)
    XCTAssertTrue(iterator.isExhausted)
  }

  func testNext_skipsUnrecognizedDataType() {
    guard let iterator = MaxMindIterator(Data([0]) + maxMindMetaData) else {
      XCTFail("Iterator should have been creatable.")
      return
    }

    assertMaxMindMetaData(iterator, of: maxMindMetaData)
    XCTAssertNil(iterator.next())
    XCTAssertTrue(iterator.isExhausted)
    iterator.rewind()
    XCTAssertFalse(iterator.isExhausted)
    assertMaxMindMetaData(iterator, of: maxMindMetaData)
    XCTAssertTrue(iterator.isExhausted)
    iterator.rewind()
  }

  func testSeek() {
    let padData = Data([
                         0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                         0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                         0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                         0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000
                       ])

    guard let iterator = MaxMindIterator(padData + maxMindMetaData) else {
      XCTFail("Iterator should have been creatable.")
      return
    }
    iterator.seek(to: padData.count)
    assertMaxMindMetaData(iterator, of: maxMindMetaData)
    XCTAssertNil(iterator.next())
    XCTAssertTrue(iterator.isExhausted)
    iterator.rewind()
    iterator.seek(to: padData.count)
    XCTAssertFalse(iterator.isExhausted)
    assertMaxMindMetaData(iterator, of: maxMindMetaData)
    XCTAssertTrue(iterator.isExhausted)

  }

}

fileprivate let maxMindMetaData = Data(
  [
    0b11101001, 0b01011011, 0b01100010, 0b01101001,
    0b01101110, 0b01100001, 0b01110010, 0b01111001,
    0b01011111, 0b01100110, 0b01101111, 0b01110010,
    0b01101101, 0b01100001, 0b01110100, 0b01011111,
    0b01101101, 0b01100001, 0b01101010, 0b01101111,
    0b01110010, 0b01011111, 0b01110110, 0b01100101,
    0b01110010, 0b01110011, 0b01101001, 0b01101111,
    0b01101110, 0b10100001, 0b00000010, 0b01011011,
    0b01100010, 0b01101001, 0b01101110, 0b01100001,
    0b01110010, 0b01111001, 0b01011111, 0b01100110,
    0b01101111, 0b01110010, 0b01101101, 0b01100001,
    0b01110100, 0b01011111, 0b01101101, 0b01101001,
    0b01101110, 0b01101111, 0b01110010, 0b01011111,
    0b01110110, 0b01100101, 0b01110010, 0b01110011,
    0b01101001, 0b01101111, 0b01101110, 0b10100000,
    0b01001011, 0b01100010, 0b01110101, 0b01101001,
    0b01101100, 0b01100100, 0b01011111, 0b01100101,
    0b01110000, 0b01101111, 0b01100011, 0b01101000,
    0b00000100, 0b00000010, 0b01011110, 0b10011110,
    0b11101000, 0b11100110, 0b01001101, 0b01100100,
    0b01100001, 0b01110100, 0b01100001, 0b01100010,
    0b01100001, 0b01110011, 0b01100101, 0b01011111,
    0b01110100, 0b01111001, 0b01110000, 0b01100101,
    0b01010000, 0b01000111, 0b01100101, 0b01101111,
    0b01001100, 0b01101001, 0b01110100, 0b01100101,
    0b00110010, 0b00101101, 0b01000011, 0b01101111,
    0b01110101, 0b01101110, 0b01110100, 0b01110010,
    0b01111001, 0b01001011, 0b01100100, 0b01100101,
    0b01110011, 0b01100011, 0b01110010, 0b01101001,
    0b01110000, 0b01110100, 0b01101001, 0b01101111,
    0b01101110, 0b11100001, 0b01000010, 0b01100101,
    0b01101110, 0b01011001, 0b01000111, 0b01100101,
    0b01101111, 0b01001100, 0b01101001, 0b01110100,
    0b01100101, 0b00110010, 0b00100000, 0b01000011,
    0b01101111, 0b01110101, 0b01101110, 0b01110100,
    0b01110010, 0b01111001, 0b00100000, 0b01100100,
    0b01100001, 0b01110100, 0b01100001, 0b01100010,
    0b01100001, 0b01110011, 0b01100101, 0b01001010,
    0b01101001, 0b01110000, 0b01011111, 0b01110110,
    0b01100101, 0b01110010, 0b01110011, 0b01101001,
    0b01101111, 0b01101110, 0b10100001, 0b00000110,
    0b01001001, 0b01101100, 0b01100001, 0b01101110,
    0b01100111, 0b01110101, 0b01100001, 0b01100111,
    0b01100101, 0b01110011, 0b00001000, 0b00000100,
    0b01000010, 0b01100100, 0b01100101, 0b01000010,
    0b01100101, 0b01101110, 0b01000010, 0b01100101,
    0b01110011, 0b01000010, 0b01100110, 0b01110010,
    0b01000010, 0b01101010, 0b01100001, 0b01000101,
    0b01110000, 0b01110100, 0b00101101, 0b01000010,
    0b01010010, 0b01000010, 0b01110010, 0b01110101,
    0b01000101, 0b01111010, 0b01101000, 0b00101101,
    0b01000011, 0b01001110, 0b01001010, 0b01101110,
    0b01101111, 0b01100100, 0b01100101, 0b01011111,
    0b01100011, 0b01101111, 0b01110101, 0b01101110,
    0b01110100, 0b11000011, 0b00001001, 0b01101111,
    0b11011011, 0b01001011, 0b01110010, 0b01100101,
    0b01100011, 0b01101111, 0b01110010, 0b01100100,
    0b01011111, 0b01110011, 0b01101001, 0b01111010,
    0b01100101, 0b10100001, 0b00011000
  ]
)
