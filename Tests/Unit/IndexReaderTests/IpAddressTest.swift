import Foundation
import XCTest
import TestResources
@testable import IndexReader

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
    XCTAssertEqual(fromFullString, fromShortenedString)
    XCTAssertEqual(fromFullString, fromShortestString)
    XCTAssertEqual(fromFullString, fromBytes)
    XCTAssertEqual(fromFullString, fromData)
    XCTAssertEqual(fromShortenedString, fromShortestString)
    XCTAssertEqual(fromShortenedString, fromBytes)
    XCTAssertEqual(fromShortenedString, fromData)
    XCTAssertEqual(fromShortestString, fromBytes)
    XCTAssertEqual(fromShortestString, fromData)
    XCTAssertEqual(fromBytes, fromData)
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
    XCTAssertEqual(v4Direct, v4ViaInit)
    XCTAssertEqual(v6LoopbackDirect, v6LoopbackViaInit)
    XCTAssertEqual(v6Direct, v6ViaInit)
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
    let v4                  = IpAddress("80.99.18.166")
    let v6ByData            = IpAddress(
      Data([
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0x00, 0x00,
             0x00, 0x00, 0xFF, 0xFF,
             80, 99, 18, 166
           ])
    )
    let v6ByStringShortened = IpAddress("::ffff:80.99.18.166")
    let v6ByStringFull      = IpAddress("0000:0000:0000:0000:0000:ffff:80.99.18.166")
    XCTAssertEqual(v4, v6ByData)
    XCTAssertEqual(v4, v6ByStringShortened)
    XCTAssertEqual(v4, v6ByStringFull)
  }

  func testDescription() {
    XCTAssertEqual(
      "0000:0000:0000:0000:0000:ffff:5063:12a6",
      IpAddress("0000:0000:0000:0000:0000:ffff:80.99.18.166").description
    )
    XCTAssertEqual("0000:0000:0000:0000:0000:ffff:5063:12a6", IpAddress("::ffff:80.99.18.166").description)
    XCTAssertEqual("0000:0000:0000:0000:0000:ffff:5063:12a6", IpAddress.v6(IpAddress("80.99.18.166")).description)

    XCTAssertEqual("192.168.6.1", IpAddress("192.168.6.1").description)
  }

  func testComparability() {
    XCTAssertGreaterThan(IpAddress("192.168.0.1"), IpAddress("192.168.0.0"))
    XCTAssertGreaterThan(IpAddress("192.168.1.0"), IpAddress("192.168.0.0"))
    XCTAssertGreaterThan(IpAddress("192.169.0.0"), IpAddress("192.168.0.0"))
    XCTAssertGreaterThan(IpAddress("193.168.0.0"), IpAddress("192.168.0.0"))
    XCTAssertGreaterThan(IpAddress("193.168.0.0"), IpAddress("80.99.18.166"))
    XCTAssertLessThan(IpAddress("192.168.0.0"), IpAddress("192.168.0.1"))
    XCTAssertLessThan(IpAddress("192.168.0.0"), IpAddress("192.168.1.0"))
    XCTAssertLessThan(IpAddress("192.168.0.0"), IpAddress("192.169.0.0"))
    XCTAssertLessThan(IpAddress("192.168.0.0"), IpAddress("193.168.0.0"))
    XCTAssertLessThan(IpAddress("80.99.18.166"), IpAddress("193.168.0.0"))
    XCTAssertGreaterThan(IpAddress("0000:0000:0000:0000:0000:ffff:5063:12a7"), IpAddress("::ffff:80.99.18.166"))
    XCTAssertGreaterThan(IpAddress("0000:0000:0000:0000:0000:ffff:5063:12a7"), IpAddress("80.99.18.166"))
    XCTAssertLessThan(IpAddress("::ffff:80.99.18.166"), IpAddress("0000:0000:0000:0000:0000:ffff:5063:12a7"))
    XCTAssertLessThan(IpAddress("80.99.18.166"), IpAddress("0000:0000:0000:0000:0000:ffff:5063:12a7"))
  }

  func testV4Netmask() {
    XCTAssertEqual(
      IpAddress(Data([0b1111_1111, 0b1111_1111, 0b1111_1100, 0b0000_0000])),
      IpAddress.v4Netmask(ofBitLength: 22)
    )
    XCTAssertEqual(
      IpAddress(Data([0b1111_1111, 0b1110_0000, 0b0000_0000, 0b0000_0000])),
      IpAddress.v4Netmask(ofBitLength: 11)
    )
    XCTAssertEqual(
      IpAddress(Data([0b1111_1111, 0b1110_0000, 0b0000_0000, 0b0000_0000])),
      IpAddress.v4Netmask(ofBitLength: 11)
    )
  }

  func testV6Netmask() {
    XCTAssertEqual(
      IpAddress(Data([
                       0b1111_1111, 0b1111_1111, 0b1111_1100, 0b0000_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000
                     ])),
      IpAddress.v6Netmask(ofBitLength: 22)
    )
    XCTAssertEqual(
      IpAddress(Data([
                       0b1111_1111, 0b1110_0000, 0b0000_0000, 0b0000_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000
                     ])),
      IpAddress.v6Netmask(ofBitLength: 11)
    )
    XCTAssertEqual(
      IpAddress(Data([
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000
                     ])),
      IpAddress.v6Netmask(ofBitLength: 92)
    )
  }

  func testBitwiseNot() {
    XCTAssertEqual(
      IpAddress(Data([0b0000_0000, 0b0000_0000, 0b1111_1111, 0b1111_1111])),
      ~IpAddress.v4Netmask(ofBitLength: 16)
    )
    XCTAssertEqual(
      IpAddress(Data([0b0000_0000, 0b1111_1111, 0b1111_1111, 0b1111_1111])),
      ~IpAddress.v4Netmask(ofBitLength: 8)
    )

    XCTAssertEqual(
      IpAddress(Data([
                       0b0000_0000, 0b0000_0000, 0b1111_1111, 0b1111_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111
                     ])),
      ~IpAddress.v6Netmask(ofBitLength: 16)
    )
    XCTAssertEqual(
      IpAddress(Data([
                       0b0000_0000, 0b1111_1111, 0b1111_1111, 0b1111_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111
                     ])),
      ~IpAddress.v6Netmask(ofBitLength: 8)
    )
    XCTAssertEqual(
      IpAddress(Data([
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_0000,
                       0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0000_1111,
                       0b1111_1111, 0b1111_1111, 0b1111_1111, 0b1111_1111
                     ])),
      ~IpAddress.v6Netmask(ofBitLength: 92)
    )
  }

  func testBitwiseAnd() {
    XCTAssertEqual(
      IpAddress(Data([0b0000_0000, 0b0000_0000, 0b0000_0000, 0b0101_1111])),
      IpAddress(Data([0b1100_0000, 0b1010_1000, 0b0000_0000, 0b0101_1111])) &
      IpAddress(Data([0b0011_1111, 0b0101_0111, 0b1111_1111, 0b0101_1111]))
    )
  }

  func testBitwiseOr() {
    XCTAssertEqual(
      IpAddress(Data([0b1111_1111, 0b1111_1111, 0b1111_1111, 0b0101_1111])),
      IpAddress(Data([0b1100_0000, 0b1010_1000, 0b0000_0000, 0b0101_1111])) |
      IpAddress(Data([0b0011_1111, 0b0101_0111, 0b1111_1111, 0b0101_1111]))
    )
  }

  func testBitwiseXor() {
    XCTAssertEqual(
      IpAddress(Data([0b1111_1111, 0b1111_1111, 0b1111_1111, 0b0000_0000])),
      IpAddress(Data([0b1100_0000, 0b1010_1000, 0b0000_0000, 0b0101_1111])) ^
      IpAddress(Data([0b0011_1111, 0b0101_0111, 0b1111_1111, 0b0101_1111]))
    )
  }

}
