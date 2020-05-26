import Foundation
import XCTest
@testable import Decoder

class ControlByteTest: XCTestCase {

  func testByteCount_nilForValuesWhichHaveNoByteCountExposure() {
    for stubByteCount: UInt32 in 0...5 {
      XCTAssertNil(ControlByte.map(entryCount: stubByteCount).byteCount)
      XCTAssertNil(ControlByte.array(entryCount: stubByteCount).byteCount)
      XCTAssertNil(ControlByte.dataCacheContainer(entryCount: stubByteCount).byteCount)
      XCTAssertNil(ControlByte.endMarker.byteCount)
      XCTAssertNil(ControlByte.boolean(payload: true).byteCount)
      XCTAssertNil(ControlByte.boolean(payload: false).byteCount)
    }
  }

  func testByteCount_returnsWrappedPayloadSize() {
    for stubByteCount: UInt32 in 0...5 {
      for stubStrayBits: UInt8 in 0b0000_0000...0b0000_0111 {
        XCTAssertEqual(
          stubByteCount,
          ControlByte.pointer(payloadSize: stubByteCount, strayBits: stubStrayBits).byteCount
        )
      }
      XCTAssertEqual(stubByteCount, ControlByte.utf8String(payloadSize: stubByteCount).byteCount)
      XCTAssertEqual(stubByteCount, ControlByte.double(payloadSize: stubByteCount).byteCount)
      XCTAssertEqual(stubByteCount, ControlByte.bytes(payloadSize: stubByteCount).byteCount)
      XCTAssertEqual(stubByteCount, ControlByte.uInt16(payloadSize: stubByteCount).byteCount)
      XCTAssertEqual(stubByteCount, ControlByte.uInt32(payloadSize: stubByteCount).byteCount)
      XCTAssertEqual(stubByteCount, ControlByte.int32(payloadSize: stubByteCount).byteCount)
      XCTAssertEqual(stubByteCount, ControlByte.uInt64(payloadSize: stubByteCount).byteCount)
      XCTAssertEqual(stubByteCount, ControlByte.uInt128(payloadSize: stubByteCount).byteCount)
      XCTAssertEqual(stubByteCount, ControlByte.float(payloadSize: stubByteCount).byteCount)
    }
  }

}
