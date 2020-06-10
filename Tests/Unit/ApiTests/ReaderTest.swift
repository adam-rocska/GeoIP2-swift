import Foundation
import XCTest
import TestResources
@testable import struct MetadataReader.Metadata
@testable import class Api.Reader
import enum Decoder.Payload
import enum IndexReader.IpAddress
import protocol Api.DictionaryInitialisableModel
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
    let expectedNetmask       = IpAddress.v4(255, 255, 255, 0)
    let mockDBReader = MockDBReader { actualIp in
      XCTAssertEqual(expectedIp, actualIp)
      dbReaderLookupCalled = true
      return (stubDictionary, expectedNetmask)
    }
    let reader = ApiReader<MockModel>(dbReader: mockDBReader)
    let model  = reader.lookup(expectedIp)
    XCTAssertEqual(stubDictionary, model?.dictionary)
    XCTAssertEqual(expectedIp, model?.ipAddress)
    XCTAssertEqual(expectedNetmask, model?.netmask)
    XCTAssertTrue(dbReaderLookupCalled)
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

  private let mockGet: (IpAddress) -> ([String: Payload], IpAddress)?

  init(mockGet: @escaping (IpAddress) -> ([String: Payload], IpAddress)?) {
    self.mockGet = mockGet
  }

  func get(_ ip: IpAddress) -> LookupResult? { return mockGet(ip) }

}

struct MockModel: DictionaryInitialisableModel {

  let dictionary: [String: Payload]?
  let ipAddress:  IpAddress
  let netmask:    IpAddress

  init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.ipAddress = ip
    self.netmask = netmask
    self.dictionary = dictionary
  }

}