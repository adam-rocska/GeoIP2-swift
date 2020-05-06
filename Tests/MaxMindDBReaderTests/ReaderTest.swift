import Foundation
import XCTest
@testable import MaxMindDBReader

class ReaderTest: XCTestCase {

  func testInit_byFilePath() throws {
    guard let countryFilePath = bundle.path(
      forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
      ofType: "mmdb"
    ) else { fatalError("GeoLite2 Country DB file was not found.") }

    let reader = try Reader(fileAtPath: countryFilePath)
    // TODO : dumb test, but good enough assumption for now
    XCTAssertEqual(1587472614, reader.metadata.buildEpoch)
  }

  func testInit_byData() throws {
    guard let countryFilePath = bundle.path(
      forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
      ofType: "mmdb"
    ) else { fatalError("GeoLite2 Country DB file was not found.") }

    guard let inputStream = InputStream(fileAtPath: countryFilePath) else {
      fatalError("Couldn't read file.")
    }

    let reader = try Reader(data: Data(inputStream: inputStream))
    // TODO : dumb test, but good enough assumption for now
    XCTAssertEqual(1587472614, reader.metadata.buildEpoch)
  }

}
