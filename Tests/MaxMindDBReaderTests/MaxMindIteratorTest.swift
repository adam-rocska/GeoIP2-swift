import Foundation
import XCTest
@testable import MaxMindDBReader

class MaxMindIteratorTest: XCTestCase {

  func testInit_returnsNilIfDataIsEmpty() {
    XCTAssertNil(MaxMindIterator(Data()))
  }

  func testNextControlByte_noneDefined() {
    let iterator = MaxMindIterator(Data(count: 150))
    for _ in 0..<200 {
      XCTAssertNil(iterator?.nextControlByte())
    }
  }

}
