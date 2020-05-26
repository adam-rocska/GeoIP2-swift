import Foundation
import XCTest
@testable import Decoder

class DecoderTest: XCTestCase {

  func testRead_returnsNilIfIndexIsNotInData() {
    for byteCount in 100...150 {
      let data           = Data(repeating: 0xFF, count: byteCount)
      let decoder        = Decoder(
        data: data,
        controlByteInterpreter: MockControlByteInterpreter(),
        payloadInterpreter: MockPayloadInterpreter()
      )
      let exceedingIndex = byteCount + 1
      XCTAssertNil(
        decoder.read(at: exceedingIndex),
        "Should have returned nil for \(data as NSData) when looking up an exceeding index of \(exceedingIndex)"
      )
    }
  }

  func testRead_returnsNilIfControlByteInterpreterDidNotSucceed() {
    let numberOfBytes = 128
    var data          = Data(capacity: numberOfBytes)
    for byte in 0..<numberOfBytes { data.append(UInt8(byte)) }
    let range = Range(uncheckedBounds: (lower: 0, upper: numberOfBytes))
    for indexToStartLookupFrom in range {
      let expectedSubdataToInterpretByControlByte: Data
      if indexToStartLookupFrom > range.upperBound - 5 {
        expectedSubdataToInterpretByControlByte = data.subdata(
          in: Range(uncheckedBounds: (
            lower: indexToStartLookupFrom,
            upper: data.endIndex
          ))
        )
      } else {
        expectedSubdataToInterpretByControlByte = data.subdata(
          in: Range(uncheckedBounds: (
            lower: indexToStartLookupFrom,
            upper: indexToStartLookupFrom + 5
          ))
        )
      }
      var interpretCalled = false
      let decoder = Decoder(
        data: data,
        controlByteInterpreter: MockControlByteInterpreter() { data, sourceEndianness in
          XCTAssertEqual(
            expectedSubdataToInterpretByControlByte,
            data,
            "Expected to interpret \(expectedSubdataToInterpretByControlByte as NSData) but got \(data as NSData) with sourceEndianness \(sourceEndianness)"
          )
          XCTAssertEqual(.big, sourceEndianness)
          interpretCalled = true
          return nil
        },
        payloadInterpreter: MockPayloadInterpreter()
      )
      XCTAssertNil(decoder.read(at: indexToStartLookupFrom))
      XCTAssertTrue(interpretCalled, "Interpreter should have been called.")
    }
  }

}

fileprivate class MockControlByteInterpreter: ControlByteInterpreter {

  private var mockInterpretation: (Data, Endianness) -> InterpretationResult? = { _, _ in nil }

  convenience init() {
    self.init(
      typeResolver: { _, _ in nil },
      payloadSizeResolver: { _, _, _ in nil },
      definitionSizeResolver: { _, _, _ in nil }
    )
  }

  convenience init(mockInterpretation: @escaping (Data, Endianness) -> InterpretationResult?) {
    self.init()
    self.mockInterpretation = mockInterpretation
  }

  override func interpret(bytes: Data, sourceEndianness: Endianness) -> InterpretationResult? {
    return mockInterpretation(bytes, sourceEndianness)
  }
}

fileprivate class MockPayloadInterpreter: PayloadInterpreter {
  override func interpret(input: Input, using decoder: Decoder, resolvePointers: Bool) -> Payload? {
    return nil
  }
}

// 7f 7e 7d 7c 7b
// 04 03 02 01 00