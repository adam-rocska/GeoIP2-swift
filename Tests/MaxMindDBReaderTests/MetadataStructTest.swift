import Foundation
import XCTest
@testable import MaxMindDBReader

fileprivate struct MetadataTestImpl: Metadata {
  let nodeCount:                UInt32
  let recordSize:               UInt16
  let ipVersion:                UInt16                = 4
  let databaseType:             String                = ""
  let languages:                [String]              = [""]
  let binaryFormatMajorVersion: UInt16                = 1
  let binaryFormatMinorVersion: UInt16                = 3
  let buildEpoch:               UInt64                = 1588065718
  let description:              LanguageToDescription = [:]
}

class MetadataStructTest: XCTestCase {

  private func createTestMetadata(nodeCount: UInt32, recordSize: UInt16) -> Metadata {
    return MetadataTestImpl(
      nodeCount: nodeCount,
      recordSize: recordSize
    )
  }

  private func assertCalculatedValues(nodeCount: UInt32, recordSize: UInt16) {
    let expectedNodeByteSize: UInt16 = recordSize / 4
    let expectedSearchTreeSize       = UInt64(nodeCount * UInt32(expectedNodeByteSize))
    XCTAssertEqual(
      expectedNodeByteSize,
      createTestMetadata(nodeCount: nodeCount, recordSize: recordSize).nodeByteSize
    )
    XCTAssertEqual(
      expectedSearchTreeSize,
      createTestMetadata(nodeCount: nodeCount, recordSize: recordSize).searchTreeSize
    )
  }

  func testCalculatedValues() {
    assertCalculatedValues(nodeCount: 3, recordSize: 3)
    assertCalculatedValues(nodeCount: 3, recordSize: 10)
    assertCalculatedValues(nodeCount: 3, recordSize: 100)
    assertCalculatedValues(nodeCount: 3, recordSize: 1000)
    assertCalculatedValues(nodeCount: 3, recordSize: 1000)
    assertCalculatedValues(nodeCount: 3, recordSize: 10000)
    assertCalculatedValues(nodeCount: 5, recordSize: 3)
    assertCalculatedValues(nodeCount: 5, recordSize: 10)
    assertCalculatedValues(nodeCount: 5, recordSize: 100)
    assertCalculatedValues(nodeCount: 5, recordSize: 1000)
    assertCalculatedValues(nodeCount: 5, recordSize: 1000)
    assertCalculatedValues(nodeCount: 5, recordSize: 10000)
    assertCalculatedValues(nodeCount: 500, recordSize: 3)
    assertCalculatedValues(nodeCount: 500, recordSize: 10)
    assertCalculatedValues(nodeCount: 500, recordSize: 100)
    assertCalculatedValues(nodeCount: 500, recordSize: 1000)
    assertCalculatedValues(nodeCount: 500, recordSize: 1000)
    assertCalculatedValues(nodeCount: 500, recordSize: 10000)
  }

}
