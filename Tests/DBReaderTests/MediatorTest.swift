import Foundation
import XCTest
@testable import DBReader
import enum Decoder.Payload
import enum IndexReader.IpAddress
import protocol DataSection.DataSection
import protocol IndexReader.Index
@testable import struct MetadataReader.Metadata

class MediatorTest: XCTestCase {

  private let stubMetadata = Metadata(
    nodeCount: 123,
    recordSize: 456,
    ipVersion: 4,
    databaseType: "test",
    languages: [],
    binaryFormatMajorVersion: 0,
    binaryFormatMinorVersion: 0,
    buildEpoch: 0,
    description: [:],
    metadataSectionSize: 123,
    databaseSize: 456
  )

  func testGet_returnsNilIfIndexLookupDidntSucceed() {
    let expectedIp: IpAddress       = .v4("192.168.0.1")
    var mockSearchIndexLookupCalled = false
    let mockSearchIndex = MockSearchIndex { ip in
      XCTAssertEqual(expectedIp, ip)
      mockSearchIndexLookupCalled = true
      return nil
    }
    let reader = Mediator(index: mockSearchIndex, dataSection: MockDataSection(), metadata: stubMetadata)
    XCTAssertNil(reader.get(expectedIp))
    XCTAssertTrue(mockSearchIndexLookupCalled)
  }

  func testGet_returnsNilIfDataSectionLookupDidntSucceed() {
    let pointerToSeek:   UInt       = 1234567890
    let expectedPointer: UInt       = pointerToSeek - UInt(stubMetadata.nodeCount) - 16
    let expectedIp:      IpAddress  = .v4("192.168.0.1")
    var mockSearchIndexLookupCalled = false
    let mockSearchIndex = MockSearchIndex { ip in
      XCTAssertEqual(expectedIp, ip)
      mockSearchIndexLookupCalled = true
      return pointerToSeek
    }
    var mockDataSectionCalled = false
    let mockDataSection = MockDataSection { pointer in
      XCTAssertEqual(Int(expectedPointer), pointer)
      mockDataSectionCalled = true
      return nil
    }
    let reader = Mediator(index: mockSearchIndex, dataSection: mockDataSection, metadata: stubMetadata)
    XCTAssertNil(reader.get(expectedIp))
    XCTAssertTrue(mockSearchIndexLookupCalled)
    XCTAssertTrue(mockDataSectionCalled)
  }

  func testGet_returnsDataSectionLookupResultAsIs() {
    let pointerToSeek:   UInt       = 1234567890
    let expectedPointer: UInt       = pointerToSeek - UInt(stubMetadata.nodeCount) - 16
    let expectedIp:      IpAddress  = .v4("192.168.0.1")
    let expectedLookupResult        = ["test": Payload.utf8String("Test String")]
    var mockSearchIndexLookupCalled = false
    let mockSearchIndex = MockSearchIndex { ip in
      XCTAssertEqual(expectedIp, ip)
      mockSearchIndexLookupCalled = true
      return pointerToSeek
    }
    var mockDataSectionCalled = false
    let mockDataSection = MockDataSection { pointer in
      XCTAssertEqual(Int(expectedPointer), pointer)
      mockDataSectionCalled = true
      return expectedLookupResult
    }
    let reader = Mediator(index: mockSearchIndex, dataSection: mockDataSection, metadata: stubMetadata)
    XCTAssertEqual(expectedLookupResult, reader.get(expectedIp))
    XCTAssertTrue(mockSearchIndexLookupCalled)
    XCTAssertTrue(mockDataSectionCalled)
  }

}

internal class MockSearchIndex: Index {

  typealias Pointer = UInt

  private let mockLookup: (IpAddress) -> Pointer?

  required convenience init(metadata: Metadata, stream: @autoclosure () -> InputStream) {
    self.init({ _ in nil })
  }

  init(_ mockLookup: @escaping (IpAddress) -> Pointer?) { self.mockLookup = mockLookup }

  convenience init() { self.init { _ in nil } }

  func lookup(_ ip: IpAddress) -> Pointer? { return mockLookup(ip) }
}

internal class MockDataSection: DataSection {

  static let separator = Data()

  private let mockLookup: (Int) -> [String: Payload]?

  required convenience init(metadata: Metadata, stream: @autoclosure () -> InputStream) {
    self.init({ _ in nil })
  }

  init(_ mockLookup: @escaping (Int) -> [String: Payload]?) { self.mockLookup = mockLookup }

  convenience init() { self.init { _ in nil } }

  func lookup(pointer: Int) -> [String: Payload]? { return mockLookup(pointer) }


}