import Foundation
import XCTest
@testable import Index

class IpAddressTest: XCTestCase {

  private func assertV4EqualsTuple(
    _ expected: IpV4Tuple,
    _ actual: IpAddress,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    switch actual {
      case let (.v4(tuple)): XCTAssert(expected == tuple)
      default: XCTFail("Didn't match expected pattern.", file: file, line: line)
    }
  }

  private func assertV6EqualsTuple(
    _ expected: IpV6Tuple,
    _ actual: IpAddress,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    switch actual {
      case let (.v6(tuple)): XCTAssert(expected == tuple)
      default: XCTFail("Didn't match expected pattern.", file: file, line: line)
    }
  }

  func testV4() {
    let fromString = IpAddress.v4("80.99.18.166")
    let fromBytes  = IpAddress.v4(80, 99, 18, 166)
    let fromData   = IpAddress.v4(Data([80, 99, 18, 166]))

    XCTAssertEqual(fromString, fromBytes)
    XCTAssertEqual(fromString, fromData)
    XCTAssertEqual(fromBytes, fromData)

    assertV4EqualsTuple((80, 99, 18, 166), fromString)
    assertV4EqualsTuple((80, 99, 18, 166), fromBytes)
    assertV4EqualsTuple((80, 99, 18, 166), fromData)
    XCTAssertEqual(Data([80, 99, 18, 166]), fromString.data)
    XCTAssertEqual(Data([80, 99, 18, 166]), fromString.data)
    XCTAssertEqual(Data([80, 99, 18, 166]), fromData.data)
  }

  func testV6_loopback() {
    let fromFullString  = IpAddress.v6("0000:0000:0000:0000:0000:0000:0000:0001")
    let fromShortString = IpAddress.v6("::1")
    let fromBytes       = IpAddress.v6(
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x01
    )
    let expectedData    = Data([
                                 0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x01
                               ])
    let fromData        = IpAddress.v6(expectedData)

    XCTAssertEqual(fromFullString, fromShortString)
    XCTAssertEqual(fromFullString, fromBytes)
    XCTAssertEqual(fromFullString, fromData)
    XCTAssertEqual(fromShortString, fromBytes)
    XCTAssertEqual(fromShortString, fromData)
    XCTAssertEqual(fromBytes, fromData)

    let expectedTuple: IpV6Tuple = (
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x01
    )
    assertV6EqualsTuple(expectedTuple, fromFullString)
    assertV6EqualsTuple(expectedTuple, fromShortString)
    assertV6EqualsTuple(expectedTuple, fromBytes)
    assertV6EqualsTuple(expectedTuple, fromData)
    XCTAssertEqual(expectedData, fromFullString.data)
    XCTAssertEqual(expectedData, fromShortString.data)
    XCTAssertEqual(expectedData, fromBytes.data)
    XCTAssertEqual(expectedData, fromData.data)
  }

  func testV6() {
    let fromFullString      = IpAddress.v6("2001:0db8:0000:0000:0000:ff00:0042:8329")
    let fromShortenedString = IpAddress.v6("2001:db8:0:0:0:ff00:42:8329")
    let fromShortestString  = IpAddress.v6("2001:db8::ff00:42:8329")
    let fromBytes           = IpAddress.v6(
      0x20, 0x01, 0x0d, 0xb8,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0xff, 0x00,
      0x00, 0x42, 0x83, 0x29
    )
    let fromData            = IpAddress.v6(
      Data([
             0x20, 0x01, 0x0d, 0xb8,
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0xff, 0x00,
             0x00, 0x42, 0x83, 0x29
           ])
    )
  }

  func testV6_v4Transformed() {
    XCTAssertEqual(
      IpAddress("::ffff:80.99.18.166"),
      IpAddress("80.99.18.166")
    )
  }

  func testInit_fromString() {
    XCTAssertEqual(
      IpAddress.v4("80.99.18.166"),
      IpAddress("80.99.18.166")
    )
    XCTAssertEqual(
      IpAddress.v6("0000:0000:0000:0000:0000:0000:0000:0001"),
      IpAddress("0000:0000:0000:0000:0000:0000:0000:0001")
    )
    XCTAssertEqual(
      IpAddress.v6("::1"),
      IpAddress("::1")
    )
    XCTAssertEqual(
      IpAddress.v6("2001:0db8:0000:0000:0000:ff00:0042:8329"),
      IpAddress("2001:0db8:0000:0000:0000:ff00:0042:8329")
    )
    XCTAssertEqual(
      IpAddress.v6("2001:db8:0:0:0:ff00:42:8329"),
      IpAddress("2001:db8:0:0:0:ff00:42:8329")
    )
    XCTAssertEqual(
      IpAddress.v6("2001:db8::ff00:42:8329"),
      IpAddress("2001:db8::ff00:42:8329")
    )
  }

  func testInit_fromData() {
    let v4Direct          = IpAddress.v4(Data([80, 99, 18, 166]))
    let v6LoopbackDirect  = IpAddress.v6(
      Data([
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0x00, 0x01
           ])
    )
    let v6Direct          = IpAddress.v6(
      Data([
             0x20, 0x01, 0x0d, 0xb8,
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0xff, 0x00,
             0x00, 0x42, 0x83, 0x29
           ])
    )
    let v4ViaInit         = IpAddress(Data([80, 99, 18, 166]))
    let v6LoopbackViaInit = IpAddress(
      Data([
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0x00, 0x01
           ])
    )
    let v6ViaInit         = IpAddress(
      Data([
             0x20, 0x01, 0x0d, 0xb8,
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0xff, 0x00,
             0x00, 0x42, 0x83, 0x29
           ])
    )
  }

  func testV6_fromV4() {
    let asV4     = IpAddress("80.99.18.166")
    let v6FromV4 = IpAddress.v6(asV4)
    XCTAssertEqual(
      IpAddress(
        Data([
               0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0xFF, 0xFF,
               80, 99, 18, 166
             ])
      ),
      v6FromV4
    )
  }

  func testV4EqualityWithV6() {
    XCTAssertEqual(
      IpAddress(
        Data([
               0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0x00, 0x00,
               0x00, 0x00, 0xFF, 0xFF,
               80, 99, 18, 166
             ])
      ),
      IpAddress("80.99.18.166")
    )
  }
}
