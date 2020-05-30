import Foundation
import XCTest
@testable import DBReader
import enum Decoder.Payload
import enum IndexReader.IpAddress
import protocol DataSection.DataSection
import protocol IndexReader.Index
@testable import struct MetadataReader.Metadata

class InMemoryReaderTest: XCTestCase {

  private let stubMetadata = Metadata(
    nodeCount: 0,
    recordSize: 0,
    ipVersion: 0,
    databaseType: "test",
    languages: [],
    binaryFormatMajorVersion: 0,
    binaryFormatMinorVersion: 0,
    buildEpoch: 0,
    description: [:],
    metadataSectionSize: 0,
    databaseSize: 0
  )

  func testGet_returnsNilIfIndexLookupDidntSucceed() {
    let expectedIp: IpAddress       = .v4("192.168.0.1")
    var mockSearchIndexLookupCalled = false
    let mockSearchIndex = MockSearchIndex { ip in
      XCTAssertEqual(expectedIp, ip)
      mockSearchIndexLookupCalled = true
      return nil
    }
    let reader = InMemoryReader(index: mockSearchIndex, dataSection: MockDataSection(), metadata: stubMetadata)
    XCTAssertNil(reader.get(expectedIp))
    XCTAssertTrue(mockSearchIndexLookupCalled)
  }

  func testGet_returnsNilIfDataSectionLookupDidntSucceed() {
    let expectedPointer: UInt       = 1234567890
    let expectedIp:      IpAddress  = .v4("192.168.0.1")
    var mockSearchIndexLookupCalled = false
    let mockSearchIndex = MockSearchIndex { ip in
      XCTAssertEqual(expectedIp, ip)
      mockSearchIndexLookupCalled = true
      return expectedPointer
    }
    var mockDataSectionCalled = false
    let mockDataSection = MockDataSection { pointer in
      XCTAssertEqual(Int(expectedPointer), pointer)
      mockDataSectionCalled = true
      return nil
    }
    let reader = InMemoryReader(index: mockSearchIndex, dataSection: mockDataSection, metadata: stubMetadata)
    XCTAssertNil(reader.get(expectedIp))
    XCTAssertTrue(mockSearchIndexLookupCalled)
    XCTAssertTrue(mockDataSectionCalled)
  }

  func testGet_returnsDataSectionLookupResultAsIs() {
    let expectedPointer: UInt       = 1234567890
    let expectedIp:      IpAddress  = .v4("192.168.0.1")
    let expectedLookupResult        = ["test": Payload.utf8String("Test String")]
    var mockSearchIndexLookupCalled = false
    let mockSearchIndex = MockSearchIndex { ip in
      XCTAssertEqual(expectedIp, ip)
      mockSearchIndexLookupCalled = true
      return expectedPointer
    }
    var mockDataSectionCalled = false
    let mockDataSection = MockDataSection { pointer in
      XCTAssertEqual(Int(expectedPointer), pointer)
      mockDataSectionCalled = true
      return expectedLookupResult
    }
    let reader = InMemoryReader(index: mockSearchIndex, dataSection: mockDataSection, metadata: stubMetadata)
    XCTAssertEqual(expectedLookupResult, reader.get(expectedIp))
    XCTAssertTrue(mockSearchIndexLookupCalled)
    XCTAssertTrue(mockDataSectionCalled)
  }

  func testOverall() throws {
    let factory = ReaderFactory()
    let streamFactory: () -> InputStream = {
      InputStream(
        fileAtPath: "/Users/rocskaadam/src/adam-rocska/src/GeoIP2-swift/Tests/ApiTests/Resources/GeoLite2-City_20200526/GeoLite2-City.mmdb"
//        fileAtPath: "/Users/rocskaadam/src/adam-rocska/src/GeoIP2-swift/Tests/DBReaderTests/Resources/GeoLite2-Country_20200421/GeoLite2-Country.mmdb"
      )!
    }
    let reader = try factory.makeInMemoryReader(streamFactory)
//    measure {
//      reader.get(IpAddress.v4("80.99.18.166"))
//    }
    print(reader.get(IpAddress.v4("80.99.18.166")))
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