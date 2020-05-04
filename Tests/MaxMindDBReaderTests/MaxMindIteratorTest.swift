import Foundation
import XCTest
@testable import MaxMindDBReader

class MaxMindIteratorTest: XCTestCase {

  func testInit_returnsNilIfDataIsEmpty() {
    XCTAssertNil(MaxMindIterator(Data()))
  }

  func testNextControlByte_noneDefined() {
    guard let iterator = MaxMindIterator(Data(count: 150)) else {
      XCTFail("Iterator should have been created.")
      return
    }
    for _ in 0..<200 { XCTAssertNil(iterator.nextControlByte()) }
  }

  func testNextValue_noneDefined() {
    guard let iterator = MaxMindIterator(Data(count: 150)) else {
      XCTFail("Iterator should have been created.")
      return
    }
    for _ in 0..<200 { XCTAssertNil(iterator.nextValue()) }
  }

}
