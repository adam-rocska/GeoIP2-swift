import Foundation
import XCTest
@testable import MaxMindDBReader

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
    XCTAssertEqual(fromString, fromBytes)
    XCTAssertEqual(fromBytes, fromData)

    assertV4EqualsTuple((80, 99, 18, 166), fromString)
    assertV4EqualsTuple((80, 99, 18, 166), fromBytes)
    assertV4EqualsTuple((80, 99, 18, 166), fromData)
    XCTAssertEqual(Data([80, 99, 18, 166]), fromString.data)
    XCTAssertEqual(Data([80, 99, 18, 166]), fromString.data)
    XCTAssertEqual(Data([80, 99, 18, 166]), fromData.data)
  }

}
