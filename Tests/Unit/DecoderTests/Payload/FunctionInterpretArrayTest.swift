import Foundation
import XCTest
import TestResources
@testable import Decoder

class FunctionInterpretArrayTest: XCTestCase {

  func testInterpretArray_returnsNilIfAtLeastOneElementIsUnresolved() {
    let mockDecoder = MockDecoder()
    XCTAssertNil(interpretArray(entryCount: 3, decoder: mockDecoder, payloadStart: 10, resolvePointers: true))
    XCTAssertEqual(1, mockDecoder.readCounter)
    mockDecoder.entries[ReadKey(controlByteOffset: 10, resolvePointers: true)] = (
      payload: Payload.int32(100),
      controlRange: Range(uncheckedBounds: (0, 5)),
      payloadRange: Range(uncheckedBounds: (5, 7))
    )
    XCTAssertNil(interpretArray(entryCount: 3, decoder: mockDecoder, payloadStart: 10, resolvePointers: true))
    XCTAssertEqual(3, mockDecoder.readCounter)
  }

  func testInterpretArray_constructsAndReturnsArrayIfAllElementsAreResolved() {
    let expectedArray = [
      Payload.utf8String("Test String"),
      Payload.double(123.0),
      Payload.bytes(Data([0xAB, 0xCD, 0xDE])),
      Payload.uInt16(123),
      Payload.uInt32(123),
      Payload.map(["key": Payload.utf8String("value")]),
      Payload.int32(123),
      Payload.uInt64(123),
      Payload.uInt128(Data([0xAB, 0xCD])),
      Payload.array([
                      Payload.utf8String("ab"),
                      Payload.utf8String("cd"),
                      Payload.utf8String("ef")
                    ]),
      Payload.dataCacheContainer([
                                   Payload.utf8String("ab"),
                                   Payload.utf8String("cd"),
                                   Payload.utf8String("ef")
                                 ]),
      Payload.endMarker,
      Payload.boolean(true),
      Payload.boolean(false),
      Payload.float(123.0)
    ]

    let mockDecoder = MockDecoder()

    let startOffset = 10
    var offset      = startOffset
    for (index, payload) in expectedArray.enumerated() {
      let nextOffset = offset + index + 1
      let key        = ReadKey(controlByteOffset: offset, resolvePointers: true)
      let value      = (
        payload,
        Range(uncheckedBounds: (0, 5)),
        Range(uncheckedBounds: (offset, nextOffset))
      )
      mockDecoder.entries[key] = value
      offset = nextOffset
    }

    guard let (payload, payloadSize) = interpretArray(
      entryCount: UInt32(expectedArray.count),
      decoder: mockDecoder,
      payloadStart: startOffset,
      resolvePointers: true
    ) else {
      XCTFail("Should have been able to resolve a payload")
      return
    }

    XCTAssertEqual(offset - startOffset, Int(payloadSize))
    switch payload {
      case .array(let items):
        for (index, item) in items.enumerated() {
          XCTAssertEqual(expectedArray[index], item)
        }
      default: XCTFail("Should have resolved an array payload.")
    }
  }

}

fileprivate struct ReadKey: Hashable {
  let controlByteOffset: Data.Index
  let resolvePointers:   Bool
}

fileprivate class MockDecoder: Decoder {

  var entries: [ReadKey: Decoder.Output] = [:]
  var readCounter                        = 0

  init() {
    super.init(
      data: Data([0xFF]),
      controlByteInterpreter: MockControlByteInterpreter(),
      payloadInterpreter: MockPayloadInterpreter()
    )
  }

  override func read(at controlByteOffset: Int, resolvePointers: Bool) -> Decoder.Output? {
    readCounter += 1
    return entries[ReadKey(controlByteOffset: controlByteOffset, resolvePointers: resolvePointers)]
  }
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

fileprivate class MockPayloadInterpreter: PayloadInterpreter {

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

  override func interpret(
    input: Input,
    using decoder: Decoder,
    resolvePointers: Bool
  ) -> InterpretationResult? { return nil }
}