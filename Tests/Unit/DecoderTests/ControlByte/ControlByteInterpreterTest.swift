import Foundation
import XCTest
import TestResources
@testable import Decoder

class ControlByteInterpreterTest: XCTestCase {

  private let unInvokedTypedResolver: (Data, Endianness) -> DataType? = { _, _ in
    XCTFail("Type Resolver shouldn't have even been called.")
    return nil
  }
  private let unInvokedPayloadSizeResolver: (DataType, Data, Endianness) -> UInt32? = { _, _, _ in
    XCTFail("Payload Size Resolver shouldn't have been called.")
    return nil
  }
  private let unInvokedDefinitionSizeResolver: (DataType, Data, Endianness) -> UInt8? = { _, _, _ in
    XCTFail("Definition Size Resolver shouldn't have been called.")
    return nil
  }

  func testInterpret_returnsNil_forBadBytesCount() {
    let interpreter = ControlByteInterpreter(
      typeResolver: unInvokedTypedResolver,
      payloadSizeResolver: unInvokedPayloadSizeResolver,
      definitionSizeResolver: unInvokedDefinitionSizeResolver
    )
    XCTAssertNil(
      interpreter.interpret(bytes: Data(), sourceEndianness: .big),
      "Should have returned nil for empty Data."
    )
    XCTAssertNil(
      interpreter.interpret(bytes: Data(), sourceEndianness: .little),
      "Should have returned nil for empty Data."
    )
    XCTAssertNil(
      interpreter.interpret(bytes: Data(repeating: 0x00, count: 6), sourceEndianness: .big),
      "Should have returned nil for a 6 bytes long data."
    )
    XCTAssertNil(
      interpreter.interpret(bytes: Data(repeating: 0x00, count: 6), sourceEndianness: .little),
      "Should have returned nil for a 6 bytes long data."
    )
    XCTAssertNil(
      interpreter.interpret(bytes: Data(repeating: 0x00, count: 10), sourceEndianness: .big),
      "Should have returned nil for a 10 bytes long data."
    )
    XCTAssertNil(
      interpreter.interpret(bytes: Data(repeating: 0x00, count: 10), sourceEndianness: .little),
      "Should have returned nil for a 10 bytes long data."
    )
    XCTAssertNil(
      interpreter.interpret(bytes: Data(repeating: 0x00, count: 100), sourceEndianness: .big),
      "Should have returned nil for a 100 bytes long data."
    )
    XCTAssertNil(
      interpreter.interpret(bytes: Data(repeating: 0x00, count: 100), sourceEndianness: .little),
      "Should have returned nil for a 100 bytes long data."
    )
  }

  func testInterpret_returnsNil_ifTypeResolverResolvesNil() {
    for validByteCount in 1...5 {
      for expectedEndianness: Endianness in [.big, .little] {
        let rawData               = Data(repeating: 0xff, count: validByteCount)
        var typeResolverWasCalled = false
        let interpreter = ControlByteInterpreter(
          typeResolver: { bytesToDecode, sourceEndianness in
            XCTAssertEqual(rawData, bytesToDecode)
            XCTAssertEqual(expectedEndianness, sourceEndianness)
            typeResolverWasCalled = true
            return nil
          },
          payloadSizeResolver: unInvokedPayloadSizeResolver,
          definitionSizeResolver: unInvokedDefinitionSizeResolver
        )
        XCTAssertNil(
          interpreter.interpret(bytes: rawData, sourceEndianness: expectedEndianness),
          "Interpreter should have resolved nil, as typeResolver couldn't resolve the ControlByte"
        )
        XCTAssertTrue(typeResolverWasCalled, "Injected typeResolver should have been called.")
      }
    }
  }

  func testInterpret_returnsNil_ifPayloadSizeCantResolve() {
    for validByteCount in 1...5 {
      for expectedEndianness: Endianness in [.big, .little] {
        let rawData = Data(repeating: 0xff, count: validByteCount)
        for dataType in DataType.allCases {
          var typeResolverWasCalled        = false
          var payloadSizeResolverWasCalled = false
          let interpreter = ControlByteInterpreter(
            typeResolver: { bytesToDecode, sourceEndianness in
              XCTAssertEqual(rawData, bytesToDecode)
              XCTAssertEqual(expectedEndianness, sourceEndianness)
              typeResolverWasCalled = true
              return dataType
            },
            payloadSizeResolver: { resolvedDataType, bytesToDecode, sourceEndianness in
              XCTAssertEqual(expectedEndianness, sourceEndianness)
              XCTAssertEqual(dataType, resolvedDataType, "Resolved data type should be injected.")
              payloadSizeResolverWasCalled = true
              return nil
            },
            definitionSizeResolver: unInvokedDefinitionSizeResolver
          )
          XCTAssertNil(
            interpreter.interpret(bytes: rawData, sourceEndianness: expectedEndianness),
            "Interpreter should have resolved nil, as typeResolver couldn't resolve the ControlByte"
          )
          XCTAssertTrue(typeResolverWasCalled, "Injected typeResolver should have been called.")
          XCTAssertTrue(payloadSizeResolverWasCalled, "Injected payloadSizeResolver should have been called.")
        }
      }
    }
  }

  func testInterpret_returnsNil_ifDefinitionSizeCantResolve() {
    for validByteCount in 1...5 {
      for expectedEndianness: Endianness in [.big, .little] {
        let rawData = Data(repeating: 0xff, count: validByteCount)
        for dataType in DataType.allCases {
          var typeResolverWasCalled           = false
          var payloadSizeResolverWasCalled    = false
          var definitionSizeResolverWasCalled = false
          let stubPayloadSize: UInt32         = 12345678
          let interpreter = ControlByteInterpreter(
            typeResolver: { bytesToDecode, sourceEndianness in
              XCTAssertEqual(expectedEndianness, sourceEndianness)
              XCTAssertEqual(rawData, bytesToDecode)
              typeResolverWasCalled = true
              return dataType
            },
            payloadSizeResolver: { resolvedDataType, bytesToDecode, sourceEndianness in
              XCTAssertEqual(expectedEndianness, sourceEndianness)
              XCTAssertEqual(
                dataType,
                resolvedDataType,
                "Resolved data type should be injected into the payload size resolver."
              )
              payloadSizeResolverWasCalled = true
              return stubPayloadSize
            },
            definitionSizeResolver: { resolvedDataType, bytesToDecode, sourceEndianness in
              XCTAssertEqual(expectedEndianness, sourceEndianness)
              XCTAssertEqual(
                dataType,
                resolvedDataType,
                "Resolved data type should be injected into the definition size resolver."
              )
              definitionSizeResolverWasCalled = true
              return nil
            }
          )
          XCTAssertNil(
            interpreter.interpret(bytes: rawData, sourceEndianness: expectedEndianness),
            "Interpreter should have resolved nil, as typeResolver couldn't resolve the ControlByte"
          )
          XCTAssertTrue(
            typeResolverWasCalled,
            "Injected typeResolver should have been called."
          )
          XCTAssertTrue(
            payloadSizeResolverWasCalled,
            "Injected payloadSizeResolver should have been called."
          )
          XCTAssertTrue(
            definitionSizeResolverWasCalled,
            "Injected definitionSizeResolver should have been called."
          )
        }
      }
    }
  }

  private func assertSuccessfulResolution(
    _ dataType: DataType,
    resolvedPayloadSize: UInt32,
    _ assertionCallback: (ControlByteInterpreter.InterpretationResult) -> Void
  ) {
    for validByteCount in 1...5 {
      for expectedEndianness: Endianness in [.big, .little] {
        for definitionSize: UInt8 in 1...UInt8(validByteCount) {
          let rawData = Data(repeating: 0xff, count: validByteCount)
          let interpreter = ControlByteInterpreter(
            typeResolver: { _, _ in dataType },
            payloadSizeResolver: { _, _, _ in resolvedPayloadSize },
            definitionSizeResolver: { _, _, _ in definitionSize }
          )
          guard let interpretationResult = interpreter.interpret(
            bytes: rawData,
            sourceEndianness: expectedEndianness
          ) else {
            XCTFail("Interpretation result was nil for dataType \(dataType).")
            return
          }
          XCTAssertEqual(
            rawData[..<definitionSize],
            interpretationResult.definition
          )
          assertionCallback(interpretationResult)
        }
      }
    }
  }

  func testInterpret_happyPath() {
    assertSuccessfulResolution(.pointer, resolvedPayloadSize: 1) {
      guard case let .pointer(payloadSize, strayBits) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual($0.definition[0] & 0b0000_0111, strayBits)
      XCTAssertEqual(1, payloadSize)
    }
    assertSuccessfulResolution(.utf8String, resolvedPayloadSize: 15) {
      guard case let .utf8String(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(15, payloadSize)
    }
    assertSuccessfulResolution(.double, resolvedPayloadSize: 2) {
      guard case let .double(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(2, payloadSize)
    }
    assertSuccessfulResolution(.bytes, resolvedPayloadSize: 1) {
      guard case let .bytes(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(1, payloadSize)
    }
    assertSuccessfulResolution(.uInt16, resolvedPayloadSize: 2) {
      guard case let .uInt16(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(2, payloadSize)
    }
    assertSuccessfulResolution(.uInt32, resolvedPayloadSize: 3) {
      guard case let .uInt32(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(3, payloadSize)
    }
    assertSuccessfulResolution(.map, resolvedPayloadSize: 21) {
      guard case let .map(entryCount) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(21, entryCount)
    }
    assertSuccessfulResolution(.int32, resolvedPayloadSize: 3) {
      guard case let .int32(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(3, payloadSize)
    }
    assertSuccessfulResolution(.uInt64, resolvedPayloadSize: 4) {
      guard case let .uInt64(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(4, payloadSize)
    }
    assertSuccessfulResolution(.uInt128, resolvedPayloadSize: 5) {
      guard case let .uInt128(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(5, payloadSize)
    }
    assertSuccessfulResolution(.array, resolvedPayloadSize: 21) {
      guard case let .array(entryCount) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(21, entryCount)
    }
    assertSuccessfulResolution(.dataCacheContainer, resolvedPayloadSize: 50) {
      guard case let .dataCacheContainer(entryCount) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(50, entryCount)
    }
    assertSuccessfulResolution(.endMarker, resolvedPayloadSize: 50) {
      XCTAssertEqual(ControlByte.endMarker, $0.controlByte)
    }
    assertSuccessfulResolution(.boolean, resolvedPayloadSize: 0) {
      guard case let .boolean(payload) = $0.controlByte else { XCTFail(); return }
      XCTAssertFalse(payload)
    }
    assertSuccessfulResolution(.boolean, resolvedPayloadSize: 1) {
      guard case let .boolean(payload) = $0.controlByte else { XCTFail(); return }
      XCTAssertTrue(payload)
    }
    assertSuccessfulResolution(.boolean, resolvedPayloadSize: 49) {
      guard case let .boolean(payload) = $0.controlByte else { XCTFail(); return }
      XCTAssertTrue(payload)
    }
    assertSuccessfulResolution(.float, resolvedPayloadSize: 3) {
      guard case let .float(payloadSize) = $0.controlByte else { XCTFail(); return }
      XCTAssertEqual(3, payloadSize)
    }
  }

}
