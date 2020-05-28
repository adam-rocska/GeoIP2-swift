import Foundation
import XCTest
@testable import Decoder

class FunctionInterpretPointerTest: XCTestCase {

  func assertNilForPayload(_ payloadSize: UInt32, file: StaticString = #file, line: UInt = #line) {
    XCTAssertNil(
      interpretPointer(
        bytes: Data(),
        payloadSize: payloadSize,
        strayBits: 0,
        sourceEndianness: .big,
        resolvePointers: false,
        decoder: MockDecoder()
      ),
      file: file,
      line: line
    )
  }

  func testInterpretPointer_returnsNilIfPayloadSizeIsNotInAcceptableRange() {
    assertNilForPayload(0)
    assertNilForPayload(5)
    assertNilForPayload(10)
    assertNilForPayload(20)
  }

  // TODO : Figure out a way to write proper unit tests for this php fantasy shit

}

fileprivate class MockDecoder: Decoder {
  init() {
    super.init(
      data: Data([0x00]),
      controlByteInterpreter: StubControlByteInterpreter(),
      payloadInterpreter: StubPayloadInterpreter()
    )
  }

  override func read(at controlByteOffset: Int, resolvePointers: Bool) -> Decoder.Output? {
    return nil
  }
}

fileprivate class StubControlByteInterpreter: ControlByteInterpreter {

  init() {
    super.init(
      typeResolver: { _, _ in nil },
      payloadSizeResolver: { _, _, _ in nil },
      definitionSizeResolver: { _, _, _ in nil }
    )
  }

  override func interpret(bytes: Data, sourceEndianness: Endianness) -> InterpretationResult? {
    return nil
  }
}

fileprivate class StubPayloadInterpreter: PayloadInterpreter {

  init() {
    super.init(
      interpretArray: { _, _, _, _ in nil },
      interpretDataCacheContainer: { _, _, _, _ in nil },
      interpretDouble: { _, _ in nil },
      interpretFloat: { _, _ in nil },
      interpretInt32: { _, _ in nil },
      interpretMap: { _, _, _, _ in nil },
      interpretPointer: { _, _, _, _, _, _ in nil },
      interpretUInt16: { _, _ in nil },
      interpretUInt32: { _, _ in nil },
      interpretUInt64: { _, _ in nil },
      interpretUtf8String: { _ in nil }
    )
  }

  override func interpret(input: Input, using decoder: Decoder, resolvePointers: Bool) -> InterpretationResult? {
    return nil
  }
}