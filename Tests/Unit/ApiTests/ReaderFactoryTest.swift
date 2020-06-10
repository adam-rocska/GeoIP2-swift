import Foundation
import XCTest
import TestResources
@testable import class Api.ReaderFactory
@testable import struct MetadataReader.Metadata
import enum Api.DatabaseType
import enum Decoder.Payload
import enum IndexReader.IpAddress
import class Api.Reader
import protocol DBReader.Reader
import protocol DBReader.ReaderFactory
import protocol Api.DictionaryInitialisableModel

fileprivate typealias ApiReader = Api.Reader
fileprivate typealias ApiReaderFactory = Api.ReaderFactory
fileprivate typealias DBReaderReader = DBReader.Reader
fileprivate typealias DBReaderFactory = DBReader.ReaderFactory

class ReaderFactoryTest: XCTestCase {

  private let databaseTypes = [
    DatabaseType.city,
    DatabaseType.country,
    DatabaseType.anonymousIp,
    DatabaseType.asn,
    DatabaseType.connectionType,
    DatabaseType.domain,
    DatabaseType.enterprise,
    DatabaseType.isp
  ]

  func testMakeReader_returnsNilIfSourceIsNotFileURL() {
    let factory = ApiReaderFactory()

    guard let nonFileUrl = URL(string: "https://github.com/adam-rocska/GeoIP2-swift") else {
      XCTFail("This should have worked.")
      return
    }
    for databaseType in databaseTypes {
      XCTAssertNil(
        try! factory.makeReader(source: nonFileUrl, type: databaseType) as? ApiReader<StubModel>,
        "Reader factory should have failed, as URL was a non-file URL."
      )
    }
  }

  func testMakeReader_shouldRethrowIfDbReaderConstructionFailed() {
    let mockDBReaderFactory = MockDBReaderFactory { _ in throw StubDbError.stubError }
    let apiReaderFactory = ApiReaderFactory(fileReaderFactory: mockDBReaderFactory)
    let url              = URL(fileURLWithPath: #file)
    for databaseType in databaseTypes {
      XCTAssertThrowsError(try apiReaderFactory.makeReader(source: url, type: databaseType) as? ApiReader<StubModel>) {
        error in
        XCTAssertEqual(StubDbError.stubError, error as! StubDbError)
      }
    }
  }

  func testMakeReader_injectedInputStreamFactoryShouldReturnEmptyInputStreamIfSourceIsNil() {
    let mockDbReaderFactory = MockDBReaderFactory { inputStreamFactory in
      let inputStream = inputStreamFactory()
      XCTAssertEqual(InputStream.Status.notOpen, inputStream.streamStatus)
      XCTAssertFalse(inputStream.hasBytesAvailable)
      throw StubDbError.stubError
    }
    let apiReaderFactory = ApiReaderFactory(fileReaderFactory: mockDbReaderFactory)
    let url              = URL(fileURLWithPath: "/not/exists/file")
    for databaseType in databaseTypes {
      XCTAssertThrowsError(try apiReaderFactory.makeReader(source: url, type: databaseType) as? ApiReader<StubModel>)
    }
  }

  func testMakeReader_makesAndReturnsReaderOfExpectedType() {
    let url = URL(fileURLWithPath: #file)
    for databaseType in databaseTypes {
      let mockDBReader = MockDBReader(databaseType: databaseType.rawValue) { _ in nil }
      let mockDBReaderFactory = MockDBReaderFactory { _ in mockDBReader }
      let apiReaderFactory = ApiReaderFactory(fileReaderFactory: mockDBReaderFactory)
      let apiReader        = try! apiReaderFactory.makeReader(source: url, type: databaseType) as? ApiReader<StubModel>
      XCTAssertNotNil(apiReader)
    }
  }

}

fileprivate class MockDBReaderFactory: DBReaderFactory {

  private let stubInMemoryFactory: (() -> InputStream) throws -> DBReaderReader

  init(stubInMemoryFactory: @escaping (() -> InputStream) throws -> DBReaderReader) {
    self.stubInMemoryFactory = stubInMemoryFactory
  }

  func makeInMemoryReader(_ inputStream: @escaping () -> InputStream) throws -> DBReaderReader {
    return try stubInMemoryFactory(inputStream)
  }
}

enum StubDbError: Error, Equatable { case stubError }

fileprivate class MockDBReader: DBReaderReader {
  var metadata: Metadata

  private let stubGet: (IpAddress) -> LookupResult?

  init(databaseType: String, stubGet: @escaping (IpAddress) -> LookupResult?) {
    self.stubGet = stubGet
    self.metadata = Metadata(
      nodeCount: 0,
      recordSize: 0,
      ipVersion: 0,
      databaseType: databaseType,
      languages: [],
      binaryFormatMajorVersion: 0,
      binaryFormatMinorVersion: 0,
      buildEpoch: 0,
      description: [:],
      metadataSectionSize: 0,
      databaseSize: 0
    )
  }

  func get(_ ip: IpAddress) -> LookupResult? {
    return stubGet(ip)
  }

}

struct StubModel: DictionaryInitialisableModel {
  let ipAddress: IpAddress
  let netmask:   IpAddress

  init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.ipAddress = ip
    self.netmask = netmask
  }
}