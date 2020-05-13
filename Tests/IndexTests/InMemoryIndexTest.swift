import Foundation
import XCTest
import Metadata
@testable import Index

class InMemoryIndexTest: XCTestCase {

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
    let index = InMemoryIndex<UInt>(
      metadata: InMemoryIndexTest.countryMetadata!,
      stream: InputStream(fileAtPath: InMemoryIndexTest.countryFilePath)!
    )

    print(index.lookup(.v4("80.99.18.166")))
    print(index.lookup(.v4("202.108.22.220")))
    print(index.lookup(.v4("0.0.0.0")))
  }

}
