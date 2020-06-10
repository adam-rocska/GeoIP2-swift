import Foundation
import XCTest
import TestResources
import class Api.Reader
import class Api.ReaderFactory
import struct Api.AsnModel

class AsnLookupTest: XCTestCase {

  private static var reader: Reader<AsnModel>!
  private var reader: Reader<AsnModel> { get { return AsnLookupTest.reader } }

  override static func setUp() {
    super.setUp()
    let factory = ReaderFactory()
    guard let url = bundle.url(
      forResource: "GeoLite2-ASN",
      withExtension: "mmdb",
      subdirectory: "GeoLite2-ASN_20200526"
    ) else {
      XCTFail("Could not load country database.")
      return
    }

    do {
      try reader = factory.makeReader(source: url, type: .asn)
    } catch {
      XCTFail("Couldn't initialize reader.")
    }
  }

  func testSuccessfulLookup() {
    print(reader.lookup(.v4("80.99.18.166")))
  }

}
