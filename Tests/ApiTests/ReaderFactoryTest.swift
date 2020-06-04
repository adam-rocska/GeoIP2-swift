import Foundation
import XCTest
@testable import class Api.ReaderFactory
@testable import struct MetadataReader.Metadata
import enum Api.DatabaseType
import enum Decoder.Payload
import enum IndexReader.IpAddress
import class Api.Reader
import protocol DBReader.Reader
import protocol DBReader.ReaderFactory
import protocol Api.DictionaryInitialisable

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
    let mockDBReader = MockDBReader { _ in nil }
    let url = URL(fileURLWithPath: #file)
    let mockDBReaderFactory = MockDBReaderFactory { _ in mockDBReader }
    let apiReaderFactory = ApiReaderFactory(fileReaderFactory: mockDBReaderFactory)
    for databaseType in databaseTypes {
      let apiReader = try! apiReaderFactory.makeReader(source: url, type: databaseType) as? ApiReader<StubModel>
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

  private let stubGet: (IpAddress) -> [String: Payload]?

  init(stubGet: @escaping (IpAddress) -> [String: Payload]?) {
    self.stubGet = stubGet
  }

  func get(_ ip: IpAddress) -> [String: Payload]? {
    return stubGet(ip)
  }

}

struct StubModel: DictionaryInitialisable {
  init(_ dictionary: [String: Payload]?) {}
}