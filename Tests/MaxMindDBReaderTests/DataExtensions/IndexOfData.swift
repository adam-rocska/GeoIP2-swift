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
    let testDefinitions = [
      (sequence: "Hello World".asciiData, subsequence: "World".asciiData, expectedIndex: 6),
      (sequence: "Hello world".asciiData, subsequence: "World".asciiData, expectedIndex: nil),
      (sequence: "Hello World SOME World".asciiData, subsequence: "World".asciiData, expectedIndex: 6),
      (sequence: "Hello world SOME World".asciiData, subsequence: "World".asciiData, expectedIndex: 17),
      (sequence: "Hello World".asciiData, subsequence: "Hello".asciiData, expectedIndex: 0),
      (sequence: "hello World".asciiData, subsequence: "hello".asciiData, expectedIndex: 0),
      (sequence: "hello world".asciiData, subsequence: "Hello".asciiData, expectedIndex: nil),
      (sequence: "hello World SOME World".asciiData, subsequence: "Hello".asciiData, expectedIndex: nil),
      (sequence: "hello world SOME World".asciiData, subsequence: "Hello".asciiData, expectedIndex: nil)
    ]

    for testDefinition in testDefinitions.compactMap({ $0 }) {
      XCTAssertEqual(
        testDefinition.expectedIndex,
        testDefinition.sequence.index(of: testDefinition.subsequence)
      )
    }
  }

  func testIndex_ofData_fromIndex() {
    XCTAssertEqual(12, "Hello World Hello World".asciiData.index(of: "Hello World".asciiData, from: 3))
  }
}
