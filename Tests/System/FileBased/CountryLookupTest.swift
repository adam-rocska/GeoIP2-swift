import Foundation
import XCTest
import TestResources
import class Api.Reader
import struct Api.CountryModel
import class Api.ReaderFactory

class CountryLookupTest: XCTestCase {

  private static var reader: Reader<CountryModel>!
  private var reader: Reader<CountryModel> { get { return CountryLookupTest.reader } }

  override static func setUp() {
    super.setUp()
    let factory = ReaderFactory()
    guard let url = bundle.url(
      forResource: "GeoLite2-Country",
      withExtension: "mmdb",
      subdirectory: "GeoLite2-Country_20200421"
    ) else {
      XCTFail("Could not load country database.")
      return
    }

    do {
      try reader = factory.makeReader(source: url, type: .country)
    } catch {
      XCTFail("Couldn't initialize reader.")
    }
  }

  func testSuccessfulLookup() {
    print(reader.lookup(.v4(80, 99, 18, 166)))
  }

}
