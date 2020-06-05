import Foundation
import XCTest
import TestResources
@testable import IndexReader

class LookupDirectionTest: XCTestCase {

  func testCreateLookupStack_ofByte() {
    XCTAssertEqual(
      [.left, .left, .left, .left, .right, .left, .right, .left],
      LookupDirection.createLookupStack(of: 80)
    )
    XCTAssertEqual(
      [.right, .right, .left, .left, .left, .right, .right, .left],
      LookupDirection.createLookupStack(of: 99)
    )
    XCTAssertEqual(
      [.left, .right, .left, .left, .right, .left, .left, .left],
      LookupDirection.createLookupStack(of: 18)
    )
    XCTAssertEqual(
      [.left, .right, .right, .left, .left, .right, .left, .right],
      LookupDirection.createLookupStack(of: 166)
    )
  }

  func testCreateLookupStack_ofData() {
    XCTAssertEqual(
      [.left, .right, .right, .left, .left, .right, .left, .right] +
      [.left, .right, .left, .left, .right, .left, .left, .left] +
      [.right, .right, .left, .left, .left, .right, .right, .left] +
      [.left, .left, .left, .left, .right, .left, .right, .left],
      LookupDirection.createLookupStack(of: Data([80, 99, 18, 166]))
    )
  }

}
