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
    reader.read(InputStream(fileAtPath: countryFilePath)!)
  }

}
