import Foundation
import XCTest
@testable import MaxMindDBReader

fileprivate extension String {
  var asciiData: Data { get { return self.data(using: .ascii) ?? Data() } }
}

class IndexOfData: XCTestCase {
  private typealias TestDefinition = (sequence: Data, subsequence: Data, expectedIndex: Data.Index?)

  private func testDefinition(sequence: String, subsequence: String, expectedIndex: Int?) -> TestDefinition? {
    return (
      sequence: sequence.asciiData,
      subsequence: subsequence.asciiData,
      expectedIndex: expectedIndex
    )
  }

  func testIndex_ofData() {
    XCTAssertEqual(6, "Hello World".asciiData.index(of: "World".asciiData))
    XCTAssertNil("Hello world".asciiData.index(of: "World".asciiData))
    XCTAssertEqual(6, "Hello World SOME World".asciiData.index(of: "World".asciiData))
    XCTAssertEqual(17, "Hello world SOME World".asciiData.index(of: "World".asciiData))
    XCTAssertEqual(0, "Hello World".asciiData.index(of: "Hello".asciiData))
    XCTAssertEqual(0, "hello World".asciiData.index(of: "hello".asciiData))
    XCTAssertNil("hello world".asciiData.index(of: "Hello".asciiData))
    XCTAssertNil("hello World SOME World".asciiData.index(of: "Hello".asciiData))
    XCTAssertNil("hello world SOME World".asciiData.index(of: "Hello".asciiData))
  }

  func testIndex_ofData_fromIndex() {
    XCTAssertEqual(12, "Hello World Hello World".asciiData.index(of: "Hello World".asciiData, from: 3))
  }
}
