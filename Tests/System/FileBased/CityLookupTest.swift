import Foundation
import XCTest
import TestResources
import class Api.Reader
import class Api.ReaderFactory
import enum Api.IpAddress
@testable import struct Api.CityModel

class CityLookupTest: XCTestCase {

  private static var reader: Reader<CityModel>!
  private var reader: Reader<CityModel> { get { return CityLookupTest.reader } }

  override static func setUp() {
    super.setUp()
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

  func testSuccessfulLookup() {
    "ffff:ffff:ffff:ffff:ffff:ffff:ffff:C000"
    "255.255.255.224"
    "255.255.255.192"
//    print(reader.lookup(.v6("::1.128.0.0"))?.netmask)
    print(reader.lookup(.v4(80, 99, 18, 166))?.netmask)
  }

}
