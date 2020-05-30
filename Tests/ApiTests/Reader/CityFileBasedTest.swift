import Foundation
import XCTest
@testable import Api

import protocol DBReader.Reader
import enum Index.IpAddress
import enum Decoder.Payload
@testable import struct MetadataReader.Metadata

class CityFileBasedTest: XCTestCase {

  let stubMetadata = Metadata(
    nodeCount: 0,
    recordSize: 0,
    ipVersion: 0,
    databaseType: DatabaseType.city.rawValue,
    languages: [],
    binaryFormatMajorVersion: 0,
    binaryFormatMinorVersion: 0,
    buildEpoch: 0,
    description: [:],
    metadataSectionSize: 0,
    databaseSize: 0
  )

  func testMetadataForwarding() {
    let mockReader    = MockReader(metadata: stubMetadata)
    let cityFileBased = CityFileBased(dbReader: mockReader)
    XCTAssertEqual(stubMetadata, cityFileBased.metadata)
  }

  func testLookup_returnsNilIfDbReaderDidntReturnResult() {
    let expectedIp   = IpAddress.v4("127.0.0.1")
    var getWasCalled = false
    let mockReader = MockReader(metadata: stubMetadata) { address in
      XCTAssertEqual(expectedIp, address)
      getWasCalled = true
      return nil
    }

    let cityFileBased = CityFileBased(dbReader: mockReader)
    XCTAssertNil(cityFileBased.lookup(expectedIp))
    XCTAssertTrue(getWasCalled)
  }

}

class MockReader: DBReader.Reader {

  let metadata: Metadata
  private let mockGet: (IpAddress) -> [String: Payload]?

  init(metadata: Metadata, mockGet: @escaping (IpAddress) -> [String: Payload]?) {
    self.metadata = metadata
    self.mockGet = mockGet
  }

  convenience init(metadata: Metadata) { self.init(metadata: metadata, mockGet: { _ in nil }) }

  func get(_ ip: IpAddress) -> [String: Payload]? { return mockGet(ip) }
}