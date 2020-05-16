import Foundation
import XCTest
@testable import Decoder

class ControlByteTest: XCTestCase {

  func testTypeResolution() {
    XCTAssertEqual(DataType.pointer, ControlByte.pointer(payloadSize: 123, strayBits: 0b0000_0110).type)
    XCTAssertEqual(DataType.utf8String, ControlByte.utf8String(payloadSize: 123).type)
    XCTAssertEqual(DataType.double, ControlByte.double(payloadSize: 123).type)
    XCTAssertEqual(DataType.bytes, ControlByte.bytes(payloadSize: 123).type)
    XCTAssertEqual(DataType.uInt16, ControlByte.uInt16(payloadSize: 123).type)
    XCTAssertEqual(DataType.uInt32, ControlByte.uInt32(payloadSize: 123).type)
    XCTAssertEqual(DataType.map, ControlByte.map(payloadSize: 123).type)
    XCTAssertEqual(DataType.int32, ControlByte.int32(payloadSize: 123).type)
    XCTAssertEqual(DataType.uInt64, ControlByte.uInt64(payloadSize: 123).type)
    XCTAssertEqual(DataType.uInt128, ControlByte.uInt128(payloadSize: 123).type)
    XCTAssertEqual(DataType.array, ControlByte.array(payloadSize: 123).type)
    XCTAssertEqual(DataType.dataCacheContainer, ControlByte.dataCacheContainer(payloadSize: 123).type)
    XCTAssertEqual(DataType.endMarker, ControlByte.endMarker(payloadSize: 123).type)
    XCTAssertEqual(DataType.boolean, ControlByte.boolean(payloadSize: 123).type)
    XCTAssertEqual(DataType.float, ControlByte.float(payloadSize: 123).type)
  }

}
