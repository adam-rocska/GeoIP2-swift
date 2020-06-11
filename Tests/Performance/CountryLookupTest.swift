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
    setupReader()
  }

  private static func setupReader() {
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

  func testInitialization() { measure { CountryLookupTest.setupReader() } }

  func testLookup_1() { measure { reader.lookup(.v4(80, 99, 18, 166)) } }

  func testLookup_2() { measure { reader.lookup(.v6("::1.128.0.0")) } }

  func testLookup_3() { measure { reader.lookup(.v6("::12.81.92.0")) } }

  func testLookup_4() { measure { reader.lookup(.v6("::12.81.96.0")) } }

  func testLookup_5() { measure { reader.lookup(.v6("2600:6000::")) } }

  func testLookup_6() { measure { reader.lookup(.v6("2600:7000::")) } }

  func testLookup_7() { measure { reader.lookup(.v6("2600:7100::")) } }

}
