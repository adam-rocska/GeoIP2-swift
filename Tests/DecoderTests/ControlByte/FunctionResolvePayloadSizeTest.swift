import Foundation
import XCTest
@testable import Decoder

class FunctionResolvePayloadSizeTest: XCTestCase {

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
  }

  func testResolvePayloadSize_resolvesNilIfInputIsEmpty() {
    for dataType in DataType.allCases {
      XCTAssertNil(resolvePayloadSize(dataType: dataType, bytes: Data(), sourceEndianness: .big))
      XCTAssertNil(resolvePayloadSize(dataType: dataType, bytes: Data(), sourceEndianness: .little))
    }
  }

  func testResolvePayloadSize_inputIsPointer() {
    for expectedPayloadSize in 1...4 {
      let numericValueOfBits = expectedPayloadSize - 1
      let payloadSizeBitMask = numericValueOfBits &<< 3
      let pointerifiedByte   = payloadSizeBitMask | 0b0010_0000
      for strayBits in 0b0000_0000...0b0000_0111 {
        let bytes = Data([UInt8(pointerifiedByte | strayBits)])
        XCTAssertEqual(
          UInt32(expectedPayloadSize),
          resolvePayloadSize(
            dataType: DataType.pointer,
            bytes: bytes,
            sourceEndianness: .big
          )
        )
        XCTAssertEqual(
          UInt32(expectedPayloadSize),
          resolvePayloadSize(
            dataType: DataType.pointer,
            bytes: Data(bytes.reversed()),
            sourceEndianness: .little
          )
        )
      }
    }
  }

  func testResolvePayloadSize_lessThan29() {
    for dataType in DataType.allCases {
      if dataType == .pointer { continue }
      for expectedSize in 0..<29 {
        let typeBits = dataType.rawValue &<< 5
        let input    = dataType.isExtended
                       ? Data([UInt8(expectedSize), dataType.rawValue])
                       : Data([typeBits | UInt8(expectedSize)])

        XCTAssertEqual(
          UInt32(expectedSize),
          resolvePayloadSize(
            dataType: dataType,
            bytes: input,
            sourceEndianness: .big
          )
        )
        XCTAssertEqual(
          UInt32(expectedSize),
          resolvePayloadSize(
            dataType: dataType,
            bytes: Data(input.reversed()),
            sourceEndianness: .little
          )
        )
      }
    }
  }

  func testResolvePayloadSize_exactly29_nilIfCantSliceData() {
    for dataType in DataType.allCases {
      if dataType == .pointer { continue }
      let typeBits = dataType.rawValue &<< 5
      let input    = dataType.isExtended
                     ? Data([UInt8(29), dataType.rawValue])
                     : Data([typeBits | UInt8(29)])

      XCTAssertNil(
        resolvePayloadSize(dataType: dataType, bytes: input, sourceEndianness: .big),
        "Should return nil if there aren't enough bytes to determine the payload size."
      )
      XCTAssertNil(
        resolvePayloadSize(dataType: dataType, bytes: Data(input.reversed()), sourceEndianness: .little),
        "Should return nil if there aren't enough bytes to determine the payload size."
      )
    }
  }

  func testResolvePayloadSize_greaterThan28() {
    typealias TestSpec = (
      definitionBase: UInt8,
      sizeBaseLowerBound: UInt32,
      sizeBaseUpperBound: UInt32,
      sizeIncrement: UInt32,
      consideredBytes: Int
    )
    let testSpecs: [TestSpec] = [
      (29, 0, 256, 29, 1),

      (30, 0, 256, 285, 2),
      (30, 10_000, 11_000, 285, 2),
      (30, 64_000, 65_536, 285, 2),

      (31, 0, 256, 65_821, 3),
      (31, 10_000, 11_000, 65_821, 3),
      (31, 16_776_000, 16_777_216, 65_821, 3),
    ]

    for testSpec in testSpecs {
      assertConvolutedPayloadSizeLogic(
        sizeDefinitionBase: testSpec.definitionBase,
        expectedSizeBase: Range(
          uncheckedBounds: (
            lower: testSpec.sizeBaseLowerBound,
            upper: testSpec.sizeBaseUpperBound
          )
        ),
        expectedSizeIncrement: testSpec.sizeIncrement,
        bytesToAppend: testSpec.consideredBytes
      )
    }

  }

  private func assertConvolutedPayloadSizeLogic(
    sizeDefinitionBase: UInt8,
    expectedSizeBase: Range<UInt32>,
    expectedSizeIncrement: UInt32,
    bytesToAppend: Int,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    for dataType in DataType.allCases {
      if dataType == .pointer { continue }
      let typeBits    = dataType.rawValue &<< 5
      let bytesPrefix = dataType.isExtended
                        ? Data([sizeDefinitionBase, dataType.rawValue])
                        : Data([typeBits | sizeDefinitionBase])

      for sizeBase in expectedSizeBase {
        let expectedSize       = sizeBase + expectedSizeIncrement
        let sizeBaseBytes      = Data(sizeBase, targetEndianness: .big)
        let truncatedSizeBytes = sizeBaseBytes.subdata(
          in: Range(
            uncheckedBounds: (
              lower: sizeBaseBytes.index(
                sizeBaseBytes.endIndex,
                offsetBy: -bytesToAppend,
                limitedBy: sizeBaseBytes.startIndex
              ) ?? sizeBaseBytes.startIndex,
              upper: sizeBaseBytes.endIndex
            )
          )
        )

        let input = bytesPrefix + truncatedSizeBytes
        XCTAssertEqual(
          expectedSize,
          resolvePayloadSize(
            dataType: dataType,
            bytes: input,
            sourceEndianness: .big
          ),
          "Expected to resolve binary input \(input as NSData) as \(sizeBase) + \(expectedSizeIncrement) = \(expectedSize)",
          file: file,
          line: line
        )
        XCTAssertEqual(
          expectedSize,
          resolvePayloadSize(
            dataType: dataType,
            bytes: Data(input.reversed()),
            sourceEndianness: .little
          ),
          "Expected to resolve binary input \(Data(input.reversed()) as NSData) as \(sizeBase) + \(expectedSizeIncrement) = \(expectedSize)",
          file: file,
          line: line
        )
        for bytesToTruncate in 1..<bytesToAppend {
          let inputForNil = bytesPrefix + Data(repeating: 0xFF, count: bytesToTruncate)
          XCTAssertNil(
            resolvePayloadSize(
              dataType: dataType,
              bytes: inputForNil,
              sourceEndianness: .big
            ),
            "Should return nil if there aren't enough bytes to determine the payload size."
          )
          XCTAssertNil(
            resolvePayloadSize(
              dataType: dataType,
              bytes: Data(inputForNil.reversed()),
              sourceEndianness: .little
            ),
            "Should return nil if there aren't enough bytes to determine the payload size."
          )
        }
      }
    }
  }

}
