import Foundation
import XCTest
import TestResources
import class Api.Reader
import class Api.ReaderFactory
import enum Api.IpAddress
@testable import struct Api.CityModel
@testable import struct Api.CityRecord
@testable import struct Api.ContinentRecord
@testable import struct Api.CountryRecord
@testable import struct Api.LocationRecord
@testable import struct Api.MaxMindRecord
@testable import struct Api.PostalRecord
@testable import struct Api.RepresentedCountryRecord
@testable import struct Api.SubdivisionRecord
@testable import struct Api.TraitsRecord

class CityLookupTest: XCTestCase {

  private static var reader: Reader<CityModel>!
  private var reader: Reader<CityModel> { get { return CityLookupTest.reader } }

  override static func setUp() {
    super.setUp()
    setupReader()
  }

  private static func setupReader() {
    let factory = ReaderFactory()
    guard let url = bundle.url(
      forResource: "GeoLite2-City",
      withExtension: "mmdb",
      subdirectory: "GeoLite2-City_20200526"
    ) else {
      XCTFail("Could not load country database.")
      return
    }

    do {
      try reader = factory.makeReader(source: url, type: .city)
    } catch {
      XCTFail("Couldn't initialize reader.")
    }
  }

  func testInitialization() { measure { CityLookupTest.setupReader() } }

  func testLookup_1() { measure { reader.lookup(.v4(80, 99, 18, 166)) } }

  func testLookup_2() { measure { reader.lookup(.v6("::1.128.0.0")) } }

  func testLookup_3() { measure { reader.lookup(.v6("::12.81.92.0")) } }

  func testLookup_4() { measure { reader.lookup(.v6("::12.81.96.0")) } }

  func testLookup_5() { measure { reader.lookup(.v6("2600:6000::")) } }

  func testLookup_6() { measure { reader.lookup(.v6("2600:7000::")) } }

  func testLookup_7() { measure { reader.lookup(.v6("2600:7100::")) } }

}
