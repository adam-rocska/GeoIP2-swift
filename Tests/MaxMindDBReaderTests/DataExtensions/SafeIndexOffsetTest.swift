import Foundation
import XCTest
@testable import MaxMindDBReader

class SafeIndexOffsetTest: XCTestCase {

  func testLimitedIndex_afterIndex() {
    let data = Data(count: 3)
    XCTAssertEqual(
      data.index(after: data.startIndex),
      data.limitedIndex(after: data.startIndex)
    )
    XCTAssertEqual(
      data.index(before: data.endIndex),
      data.limitedIndex(after: data.endIndex)
    )

    let dataWithOneEntry = Data([0b0000_0000])
    XCTAssertEqual(
      dataWithOneEntry.startIndex,
      dataWithOneEntry.limitedIndex(after: dataWithOneEntry.startIndex)
    )
    XCTAssertEqual(
      dataWithOneEntry.startIndex,
      dataWithOneEntry.limitedIndex(after: dataWithOneEntry.endIndex)
    )
  }

  func testLimitedIndex_beforeIndex() {
    let data = Data(count: 3)
    XCTAssertEqual(
      data.startIndex,
      data.limitedIndex(before: data.startIndex)
    )
    XCTAssertEqual(
      data.startIndex,
      data.limitedIndex(before: data.index(after: data.startIndex))
    )
    XCTAssertEqual(
      data.index(after: data.startIndex),
      data.limitedIndex(before: data.index(after: data.index(after: data.startIndex)))
    )
    XCTAssertEqual(
      data.index(before: data.endIndex),
      data.limitedIndex(before: data.index(after: data.endIndex))
    )

    let dataWithOneEntry = Data([0b0000_0000])
    XCTAssertEqual(
      dataWithOneEntry.startIndex,
      dataWithOneEntry.limitedIndex(before: dataWithOneEntry.startIndex)
    )
    XCTAssertEqual(
      dataWithOneEntry.startIndex,
      dataWithOneEntry.limitedIndex(before: dataWithOneEntry.endIndex)
    )
    XCTAssertEqual(
      dataWithOneEntry.startIndex,
      dataWithOneEntry.limitedIndex(after: dataWithOneEntry.endIndex)
    )
  }

  func testLimitedIndex_offsetBy() {
    let dataWithOneEntry = Data([0b0000_0000])
    XCTAssertEqual(
      dataWithOneEntry.startIndex,
      dataWithOneEntry.limitedIndex(dataWithOneEntry.startIndex, offsetBy: 0)
    )
    XCTAssertEqual(
      dataWithOneEntry.startIndex,
      dataWithOneEntry.limitedIndex(dataWithOneEntry.startIndex, offsetBy: 2)
    )
    XCTAssertEqual(
      dataWithOneEntry.startIndex,
      dataWithOneEntry.limitedIndex(dataWithOneEntry.startIndex, offsetBy: -2)
    )

    let data = Data(count: 5)
    XCTAssertEqual(
      data.startIndex,
      data.limitedIndex(data.endIndex, offsetBy: -10)
    )
    XCTAssertEqual(
      data.index(before: data.endIndex),
      data.limitedIndex(data.startIndex, offsetBy: 10)
    )
    XCTAssertEqual(
      data.index(after: data.startIndex),
      data.limitedIndex(data.startIndex, offsetBy: 1)
    )
    XCTAssertEqual(
      data.startIndex,
      data.limitedIndex(data.index(after: data.startIndex), offsetBy: -1)
    )
    XCTAssertEqual(
      data.index(data.startIndex, offsetBy: 3),
      data.limitedIndex(data.startIndex, offsetBy: 3)
    )
  }

}
