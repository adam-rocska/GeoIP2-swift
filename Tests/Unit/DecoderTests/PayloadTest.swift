import Foundation
import XCTest
import TestResources
@testable import Decoder

class PayloadTest: XCTestCase {

  func testUnwrap_pointer() {
    let expectedList: [UInt32] = [
      123,
      123456,
      123456789,
      1234567890,
    ]
    for expected in expectedList {
      XCTAssertEqual(expected, Payload.pointer(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as String?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as Double?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as Data?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.pointer(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_utf8String() {
    let expectedList: [String] = [
      "test",
      "test string"
    ]
    for expected in expectedList {
      XCTAssertNil(Payload.utf8String(expected).unwrap() as UInt32?)
      XCTAssertEqual(expected, Payload.utf8String(expected).unwrap() as String?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as Double?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as Data?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.utf8String(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_double() {
    let expectedList: [Double] = [
      123,
      123.456,
      123456.7890,
    ]
    for expected in expectedList {
      XCTAssertNil(Payload.double(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.double(expected).unwrap() as String?)
      XCTAssertEqual(expected, Payload.double(expected).unwrap() as Double?)
      XCTAssertNil(Payload.double(expected).unwrap() as Data?)
      XCTAssertNil(Payload.double(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.double(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.double(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.double(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.double(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.double(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.double(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_bytes() {
    let expectedList: [Data] = [
      Data(repeating: 0xFF, count: 1),
      Data(repeating: 0xFF, count: 10),
      Data(repeating: 0xFF, count: 100),
    ]
    for expected in expectedList {
      XCTAssertNil(Payload.bytes(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as String?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as Double?)
      XCTAssertEqual(expected, Payload.bytes(expected).unwrap() as Data?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.bytes(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_uInt16() {
    let expectedList: [UInt16] = [123, 1234]
    for expected in expectedList {
      XCTAssertNil(Payload.uInt16(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as String?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as Double?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as Data?)
      XCTAssertEqual(expected, Payload.uInt16(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.uInt16(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_uInt32() {
    let expectedList: [UInt32] = [123, 123456, 123456789]
    for expected in expectedList {
      XCTAssertEqual(expected, Payload.uInt32(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as String?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as Double?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as Data?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.uInt32(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_map() {
    let expected: [String: Payload] = [
      "dumb1": Payload.pointer(444),
      "dumb2": Payload.array([Payload.int32(1), Payload.int32(1), Payload.int32(1)]),
      "dumb3": Payload.endMarker,
    ]
    XCTAssertNil(Payload.map(expected).unwrap() as UInt32?)
    XCTAssertNil(Payload.map(expected).unwrap() as String?)
    XCTAssertNil(Payload.map(expected).unwrap() as Double?)
    XCTAssertNil(Payload.map(expected).unwrap() as Data?)
    XCTAssertNil(Payload.map(expected).unwrap() as UInt16?)
    XCTAssertEqual(expected, Payload.map(expected).unwrap() as [String: Payload]?)
    XCTAssertNil(Payload.map(expected).unwrap() as Int32?)
    XCTAssertNil(Payload.map(expected).unwrap() as UInt64?)
    XCTAssertNil(Payload.map(expected).unwrap() as [Payload]?)
    XCTAssertNil(Payload.map(expected).unwrap() as Bool?)
    XCTAssertNil(Payload.map(expected).unwrap() as Float?)
  }

  func testUnwrap_int32() {
    let expectedList: [Int32] = [123, 123456, 123456789]
    for expected in expectedList {
      XCTAssertNil(Payload.int32(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.int32(expected).unwrap() as String?)
      XCTAssertNil(Payload.int32(expected).unwrap() as Double?)
      XCTAssertNil(Payload.int32(expected).unwrap() as Data?)
      XCTAssertNil(Payload.int32(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.int32(expected).unwrap() as [String: Payload]?)
      XCTAssertEqual(expected, Payload.int32(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.int32(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.int32(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.int32(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.int32(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_uInt64() {
    let expectedList: [UInt64] = [123, 456, 789]
    for expected in expectedList {
      XCTAssertNil(Payload.uInt64(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as String?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as Double?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as Data?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as Int32?)
      XCTAssertEqual(expected, Payload.uInt64(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.uInt64(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_uInt128() {
    let expectedList: [Data] = [
      Data(repeating: 0x00, count: 128),
      Data(repeating: 0xFF, count: 128),
      Data(repeating: 0x99, count: 128),
    ]
    for expected in expectedList {
      XCTAssertNil(Payload.uInt128(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as String?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as Double?)
      XCTAssertEqual(expected, Payload.uInt128(expected).unwrap() as Data?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.uInt128(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_array() {
    let expected: [Payload] = [
      Payload.int32(123),
      Payload.utf8String("Php scripters put random shit in collections. We support it."),
      Payload.uInt32(1234),
      Payload.array([
                      Payload.utf8String(
                        "Oh yes, in their world it's normal to create a mixed list of things with mixed list of things containing mixed maps of things."
                      ),
                      Payload.array([Payload.int32(1), Payload.int32(1), Payload.int32(1)]),
                      Payload.map([
                                    "dumb1": Payload.pointer(444),
                                    "dumb2": Payload.array([Payload.int32(1), Payload.int32(1), Payload.int32(1)]),
                                    "dumb3": Payload.endMarker,
                                  ])
                    ])
    ]
    XCTAssertNil(Payload.array(expected).unwrap() as UInt32?)
    XCTAssertNil(Payload.array(expected).unwrap() as String?)
    XCTAssertNil(Payload.array(expected).unwrap() as Double?)
    XCTAssertNil(Payload.array(expected).unwrap() as Data?)
    XCTAssertNil(Payload.array(expected).unwrap() as UInt16?)
    XCTAssertNil(Payload.array(expected).unwrap() as [String: Payload]?)
    XCTAssertNil(Payload.array(expected).unwrap() as Int32?)
    XCTAssertNil(Payload.array(expected).unwrap() as UInt64?)
    XCTAssertEqual(expected, Payload.array(expected).unwrap() as [Payload]?)
    XCTAssertNil(Payload.array(expected).unwrap() as Bool?)
    XCTAssertNil(Payload.array(expected).unwrap() as Float?)
  }

  func testUnwrap_dataCacheContainer() {
    let expected: [Payload] = [
      Payload.pointer(123),
      Payload.utf8String("Hello"),
      Payload.double(123),
      Payload.bytes(Data(repeating: 0xFF, count: 1234)),
      Payload.uInt16(123),
      Payload.uInt32(123),
      Payload.map(["test": Payload.utf8String("hey")]),
      Payload.int32(123),
      Payload.uInt64(123),
      Payload.uInt128(Data(repeating: 0xFF, count: 128)),
      Payload.array([Payload.utf8String("item")]),
      Payload.dataCacheContainer([Payload.utf8String("cache item")]),
      Payload.endMarker,
      Payload.boolean(true),
      Payload.float(123)
    ]
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as UInt32?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as String?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as Double?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as Data?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as UInt16?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as [String: Payload]?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as Int32?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as UInt64?)
    XCTAssertEqual(expected, Payload.dataCacheContainer(expected).unwrap() as [Payload]?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as Bool?)
    XCTAssertNil(Payload.dataCacheContainer(expected).unwrap() as Float?)
  }

  func testUnwrap_boolean() {
    let expectedList: [Bool] = [true, false]
    for expected in expectedList {
      XCTAssertNil(Payload.boolean(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as String?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as Double?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as Data?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as [Payload]?)
      XCTAssertEqual(expected, Payload.boolean(expected).unwrap() as Bool?)
      XCTAssertNil(Payload.boolean(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_float() {
    let expectedList: [Float] = [
      123,
      123.456,
      123456.7890
    ]
    for expected in expectedList {
      XCTAssertNil(Payload.float(expected).unwrap() as UInt32?)
      XCTAssertNil(Payload.float(expected).unwrap() as String?)
      XCTAssertNil(Payload.float(expected).unwrap() as Double?)
      XCTAssertNil(Payload.float(expected).unwrap() as Data?)
      XCTAssertNil(Payload.float(expected).unwrap() as UInt16?)
      XCTAssertNil(Payload.float(expected).unwrap() as [String: Payload]?)
      XCTAssertNil(Payload.float(expected).unwrap() as Int32?)
      XCTAssertNil(Payload.float(expected).unwrap() as UInt64?)
      XCTAssertNil(Payload.float(expected).unwrap() as [Payload]?)
      XCTAssertNil(Payload.float(expected).unwrap() as Bool?)
      XCTAssertEqual(expected, Payload.float(expected).unwrap() as Float?)
    }
  }

  func testUnwrap_endMarker() {
    XCTAssertNil(Payload.endMarker.unwrap())
  }

}
