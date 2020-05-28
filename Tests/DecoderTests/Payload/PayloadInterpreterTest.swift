import Foundation
import XCTest
@testable import Decoder

class PayloadInterpreterTest: XCTestCase {

  func testInterpret_endMarker() {
    let interpreter = PayloadInterpreter(
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
    guard let (payload, size) = interpreter.interpret(
      input: (
        bytes: Data(),
        controlByte: ControlByte.endMarker,
        sourceEndianness: Endianness.current,
        controlStart: 123,
        payloadStart: 123
      ),
      using: MockDecoder(payloadInterpreter: interpreter),
      resolvePointers: false
    ) else {
      XCTFail("Should always resolve an endmarker type payload.")
      return
    }

    XCTAssertEqual(0, size)
    XCTAssertEqual(Payload.endMarker, payload)
  }

  func testInterpret_boolean() {
    let interpreter = PayloadInterpreter(
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
    let trueInput  = (
      bytes: Data(),
      controlByte: ControlByte.boolean(payload: true),
      sourceEndianness: Endianness.current,
      controlStart: 123,
      payloadStart: 123
    )
    let falseInput = (
      bytes: Data(),
      controlByte: ControlByte.boolean(payload: false),
      sourceEndianness: Endianness.current,
      controlStart: 123,
      payloadStart: 123
    )
    let decoder    = MockDecoder(payloadInterpreter: interpreter)
    guard let (truePayload, trueSize) = interpreter.interpret(
      input: trueInput,
      using: decoder,
      resolvePointers: false
    ) else {
      XCTFail("Should always resolve an endmarker type payload.")
      return
    }
    guard let (falsePayload, falseSize) = interpreter.interpret(
      input: falseInput,
      using: decoder,
      resolvePointers: false
    ) else {
      XCTFail("Should always resolve an endmarker type payload.")
      return
    }
    XCTAssertEqual(Payload.boolean(true), truePayload)
    XCTAssertEqual(0, trueSize)
    XCTAssertEqual(Payload.boolean(false), falsePayload)
    XCTAssertEqual(0, falseSize)
  }

  // TODO : Write the rest of these dumb tests, to make refactoring safer for the future. I will most probably attempt a
  // refactor of this crap at some point.

}

fileprivate class MockDecoder: Decoder {

  init(payloadInterpreter: PayloadInterpreter) {
    super.init(
      data: Data([0xFF]),
      controlByteInterpreter: MockControlByteInterpreter(),
      payloadInterpreter: payloadInterpreter
    )
  }

  override func read(at controlByteOffset: Int, resolvePointers: Bool) -> Decoder.Output? { return nil }
}

fileprivate class MockControlByteInterpreter: ControlByteInterpreter {
  init() {
    super.init(
      typeResolver: { _, _ in nil },
      payloadSizeResolver: { _, _, _ in nil },
      definitionSizeResolver: { _, _, _ in nil }
    )
  }

  override func interpret(bytes: Data, sourceEndianness: Endianness) -> InterpretationResult? { return nil }
}