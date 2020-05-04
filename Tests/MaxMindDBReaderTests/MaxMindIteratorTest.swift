import Foundation
import XCTest
@testable import MaxMindDBReader

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
    guard let valueBytes = iterator.next(controlByte) else {
      XCTFail(
        "Should have returned a byte sequence value of \(expectedValue).",
        file: file,
        line: line
      )
      return
    }

    XCTAssertEqual(expectedValue, decode(valueBytes), file: file, line: line)
  }

  func testNext() {
    guard let iterator = MaxMindIterator(maxMindMetaData) else {
      XCTFail("Iterator should have been creatable.")
      return
    }
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
      decoder: { data -> String in decoder.decode(data) }
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
      decoder: { data -> String in decoder.decode(data) }
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
      decoder: { data -> String in decoder.decode(data) }
    )

    assertNext(
      iterator,
      type: .uInt64,
      payloadSize: 4,
      definitionSize: 2,
      expectedValue: UInt64(111),
      decoder: decoder.decode
    )
//
//    print(iterator.next())
//    print(iterator.next())
//    print(iterator.next())
//    print(iterator.next())
//    print(iterator.next())
//    print(iterator.next())
//    print(iterator.next())
//    print(iterator.next())
//    print(iterator.next())
  }

}

fileprivate let maxMindMetaData = Data([
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
                                       ])
