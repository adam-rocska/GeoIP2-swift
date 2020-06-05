import Foundation
import XCTest
import TestResources
@testable import class MetadataReader.Reader
@testable import struct MetadataReader.Metadata

class ReaderTest: XCTestCase {

  func testRead() {
    guard let countryFilePath = bundle.path(
      forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
      ofType: "mmdb"
    ) else { fatalError("GeoLite2 Country DB file was not found.") }

    let reader = Reader(windowSize: 1024)
    guard let stream = InputStream(fileAtPath: countryFilePath) else {
      preconditionFailure("Should have been able to create an input stream to file \"\(countryFilePath)\".")
    }
    guard let actualMetadata = reader.read(stream) else {
      preconditionFailure("Should have been able to read the expected metadata.")
    }
    XCTAssertEqual(expectedMetaData, actualMetadata)
    XCTAssertEqual(
      expectedMetaData.databaseSize - expectedMetaData.metadataSectionSize - Int(expectedMetaData.searchTreeSize),
      actualMetadata.dataSectionSize
    )
    XCTAssertEqual(
      Int(actualMetadata.searchTreeSize) +
      actualMetadata.dataSectionSize +
      actualMetadata.metadataSectionSize,
      actualMetadata.databaseSize)
  }

}

fileprivate let expectedMetaData = Metadata(
  nodeCount: 618459,
  recordSize: 24,
  ipVersion: 6,
  databaseType: "GeoLite2-Country",
  languages: ["de", "en", "es", "fr", "ja", "pt-BR", "ru", "zh-CN"],
  binaryFormatMajorVersion: 2,
  binaryFormatMinorVersion: 0,
  buildEpoch: 1587472614,
  description: ["en": "GeoLite2 Country database"],

  metadataSectionSize: 249,
  databaseSize: 3803555
)