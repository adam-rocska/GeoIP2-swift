import Foundation
import XCTest
@testable import IndexReader

class DataTest: XCTestCase {

  func testChunked() {
    let data    = Data([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    let chunked = data.chunked(into: 2)
    XCTAssertEqual(Data([1, 2]), chunked[0])
    XCTAssertEqual(Data([3, 4]), chunked[1])
    XCTAssertEqual(Data([5, 6]), chunked[2])
    XCTAssertEqual(Data([7, 8]), chunked[3])
    XCTAssertEqual(Data([9, 10]), chunked[4])
    XCTAssertEqual(5, chunked.count)
  }

}
