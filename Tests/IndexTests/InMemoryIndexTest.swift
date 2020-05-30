import Foundation
import XCTest
import class MetadataReader.Reader
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

    XCTAssertEqual(628171, index.lookup(IpAddress("80.99.18.166")))
    XCTAssertEqual(618846, index.lookup(IpAddress("202.108.22.220")))
    XCTAssertNil(index.lookup(IpAddress("0.0.0.0")))
    XCTAssertNil(index.lookup(IpAddress("255.255.255.255")))
    XCTAssertNil(index.lookup(IpAddress("2001:db8::8a2e:370:7334")))
    XCTAssertEqual(627015, index.lookup(IpAddress("2001:428:4c06:f000::280")))
  }

}
