import Foundation
import XCTest
@testable import struct MetadataReader.Metadata
@testable import class Api.Reader
import enum Decoder.Payload
import enum IndexReader.IpAddress
import protocol Api.DictionaryInitialisable
import protocol DBReader.Reader

fileprivate typealias ApiReader = Api.Reader
fileprivate typealias DBReaderReader = DBReader.Reader

class ReaderTest: XCTestCase {

  func testLookup_returnsNilIfDbReaderLookupResolvedNil() {
    let expectedIp: IpAddress = .v4("127.0.0.1")
    var dbReaderLookupCalled  = false
    let mockDBReader = MockDBReader { actualIp in
      XCTAssertEqual(expectedIp, actualIp)
      dbReaderLookupCalled = true
      return nil
    }
    let reader = ApiReader<MockModel>(dbReader: mockDBReader)
    XCTAssertNil(reader.lookup(expectedIp))
    XCTAssertTrue(dbReaderLookupCalled)
  }

  func testLookup_returnsTheConstructedModelIfResolved() {
    let expectedIp: IpAddress = .v4("127.0.0.1")
    var dbReaderLookupCalled  = false
    let stubDictionary        = [
      "testString": Payload.utf8String("test"),
      "testMap": Payload.map(["key": Payload.int32(123)])
    ]
    let mockDBReader = MockDBReader { actualIp in
      XCTAssertEqual(expectedIp, actualIp)
      dbReaderLookupCalled = true
      return stubDictionary
    }
    let reader = ApiReader<MockModel>(dbReader: mockDBReader)
    let model  = reader.lookup(expectedIp)
    XCTAssertEqual(stubDictionary, model?.dictionary)
  }

}

fileprivate class MockDBReader: DBReaderReader {
  var metadata = Metadata(
    nodeCount: 0,
    recordSize: 0,
    ipVersion: 0,
    databaseType: "",
    languages: [],
    binaryFormatMajorVersion: 0,
    binaryFormatMinorVersion: 0,
    buildEpoch: 0,
    description: [:],
    metadataSectionSize: 0,
    databaseSize: 0
  )

  private let mockGet: (IpAddress) -> [String: Payload]?

  init(mockGet: @escaping (IpAddress) -> [String: Payload]?) {
    self.mockGet = mockGet
  }

  func get(_ ip: IpAddress) -> [String: Payload]? { return mockGet(ip) }

}

struct MockModel: DictionaryInitialisable {

  let dictionary: [String: Payload]?

  init(_ dictionary: [String: Payload]?) { self.dictionary = dictionary }

}