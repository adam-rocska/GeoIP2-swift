import Foundation
import XCTest
@testable import Metadata

class ReaderTest: XCTestCase {

  func testRead() {
    guard let countryFilePath = bundle.path(
      forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
      ofType: "mmdb"
    ) else { fatalError("GeoLite2 Country DB file was not found.") }

    let reader = Reader(windowSize: 1024)
    XCTAssertEqual(expectedMetaData, reader.read(InputStream(fileAtPath: countryFilePath)!))
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
  description: ["en": "GeoLite2 Country database"]
)