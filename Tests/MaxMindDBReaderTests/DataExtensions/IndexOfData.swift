import Foundation
import XCTest
@testable import MaxMindDBReader

class IndexOfData: XCTestCase {
  private typealias TestDefinition = (sequence: Data, subsequence: Data, expectedIndex: Data.Index?)

  private func testDefinition(sequence: String, subsequence: String, expectedIndex: Int?) -> TestDefinition? {
    guard let dataSequence = sequence.data(using: .ascii) else {
      XCTFail("Could not represent sequence String as Data using ASCII encoding.")
      return nil
    }
    guard let dataSubsequence = subsequence.data(using: .ascii) else {
      XCTFail("Could not represent subsequence String as Data using ASCII encoding.")
      return nil
    }
    return (
      sequence: dataSequence,
      subsequence: dataSubsequence,
      expectedIndex: expectedIndex
    )
  }

  func testIndexOfData() {
    let testDefinitions = [
      testDefinition(sequence: "Hello World", subsequence: "World", expectedIndex: 6),
      testDefinition(sequence: "Hello world", subsequence: "World", expectedIndex: nil),
      testDefinition(sequence: "Hello World SOME World", subsequence: "World", expectedIndex: 6),
      testDefinition(sequence: "Hello world SOME World", subsequence: "World", expectedIndex: 17),

      testDefinition(sequence: "Hello World", subsequence: "Hello", expectedIndex: 0),
      testDefinition(sequence: "hello World", subsequence: "hello", expectedIndex: 0),
      testDefinition(sequence: "hello world", subsequence: "Hello", expectedIndex: nil),
      testDefinition(sequence: "hello World SOME World", subsequence: "Hello", expectedIndex: nil),
      testDefinition(sequence: "hello world SOME World", subsequence: "Hello", expectedIndex: nil)
    ]

    for testDefinition in testDefinitions.compactMap({ $0 }) {
      XCTAssertEqual(
        testDefinition.expectedIndex,
        testDefinition.sequence.index(of: testDefinition.subsequence)
      )
    }
  }
}
