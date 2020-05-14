import Foundation
import XCTest
import Metadata
@testable import DataSection

class InMemoryDataSectionTest: XCTestCase {

  private static var countryFilePath: String {
    get {
      guard let countryFilePath = bundle.path(
        forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
        ofType: "mmdb"
      ) else { fatalError("GeoLite2 Country DB file was not found.") }
      return countryFilePath
    }
  }

  private static let countryMetadata = Reader(windowSize: 1024).read(
    InputStream(fileAtPath: countryFilePath)!
  )

  func testLookup() {
    let section = InMemoryDataSection(
      metadata: InMemoryDataSectionTest.countryMetadata!,
      stream: InputStream(fileAtPath: InMemoryDataSectionTest.countryFilePath)!
    )
  }

}
