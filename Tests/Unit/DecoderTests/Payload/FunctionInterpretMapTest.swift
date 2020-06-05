import Foundation
import XCTest
import TestResources
@testable import Decoder

class FunctionInterpretMapTest: XCTestCase {

  func testInterpretMap_returnsNilIfKeyDoesntResolveToString() {
    let mockDecoder = MockDecoder()
    XCTAssertNil(interpretMap(entryCount: 3, decoder: mockDecoder, payloadStart: 10, resolvePointers: true))
    XCTAssertEqual(1, mockDecoder.readCounter)

    mockDecoder.entries[ReadKey(controlByteOffset: 10, resolvePointers: true)] = (
      payload: Payload.int32(100),
      controlRange: Range(uncheckedBounds: (0, 5)),
      payloadRange: Range(uncheckedBounds: (5, 7))
    )
    XCTAssertNil(interpretMap(entryCount: 3, decoder: mockDecoder, payloadStart: 10, resolvePointers: true))
    XCTAssertEqual(2, mockDecoder.readCounter)
  }

  func testInterpretMap_returnsNilIfAnyValueCantResolve() {
    let mockDecoder = MockDecoder()
    mockDecoder.entries[ReadKey(controlByteOffset: 10, resolvePointers: true)] = (
      payload: Payload.utf8String("key1"),
      controlRange: Range(uncheckedBounds: (0, 5)),
      payloadRange: Range(uncheckedBounds: (5, 7))
    )
    XCTAssertNil(interpretMap(entryCount: 3, decoder: mockDecoder, payloadStart: 10, resolvePointers: true))
    XCTAssertEqual(2, mockDecoder.readCounter)
  }

  func testInterpretMap_serializesAndReturnsExpectedMap() {
    let expectedMap: [String: Payload] = [
      "utf8String": Payload.utf8String("Test String"),
      "double": Payload.double(123.0),
      "bytes": Payload.bytes(Data([0xAB, 0xCD, 0xDE])),
      "uInt16": Payload.uInt16(123),
      "uInt32": Payload.uInt32(123),
      "map": Payload.map(["key": Payload.utf8String("value")]),
      "int32": Payload.int32(123),
      "uInt64": Payload.uInt64(123),
      "uInt128": Payload.uInt128(Data([0xAB, 0xCD])),
      "array": Payload.array([
                               Payload.utf8String("ab"),
                               Payload.utf8String("cd"),
                               Payload.utf8String("ef")
                             ]),
      "dataCacheContainer": Payload.dataCacheContainer([
                                                         Payload.utf8String("ab"),
                                                         Payload.utf8String("cd"),
                                                         Payload.utf8String("ef")
                                                       ]),
      "endMarker": Payload.endMarker,
      "booleanTrue": Payload.boolean(true),
      "booleanFalse": Payload.boolean(false),
      "float": Payload.float(123.0)
    ]

    let mockDecoder = MockDecoder(10)
    for (key, value) in expectedMap {
      mockDecoder.pushNextMockEntry(Payload.utf8String(key))
      mockDecoder.pushNextMockEntry(value)
    }

    guard let (payload, byteCount) = interpretMap(
      entryCount: UInt32(expectedMap.count),
      decoder: mockDecoder,
      payloadStart: 10,
      resolvePointers: true
    ) else {
      XCTFail("Should have been able to resolve a payload.")
      return
    }

    XCTAssertEqual(
      UInt32(mockDecoder.lastOffset - mockDecoder.startOffset),
      byteCount
    )
    switch payload {
      case .map(let actualMap):
        for (key, value) in actualMap {
          XCTAssertEqual(expectedMap[key], value)
        }
      default:
        XCTFail("Should have resolved a map payload.")
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

  let startOffset: Int
  private(set) var lastOffset: Int

  func pushNextMockEntry(_ payload: Payload) {
    let nextOffset = lastOffset + entries.count + 1
    let key        = ReadKey(controlByteOffset: lastOffset, resolvePointers: true)
    let value      = (
      payload,
      Range(uncheckedBounds: (0, 5)),
      Range(uncheckedBounds: (lastOffset, nextOffset))
    )
    entries[key] = value
    lastOffset = nextOffset
  }

  init(_ startOffset: Int = 0) {
    self.startOffset = startOffset
    self.lastOffset = startOffset
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