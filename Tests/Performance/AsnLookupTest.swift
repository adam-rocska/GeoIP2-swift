import Foundation
import XCTest
import TestResources
import class Api.Reader
import class Api.ReaderFactory
import enum Api.IpAddress
@testable import struct Api.AsnModel

class AsnLookupTest: XCTestCase {

  private static var reader: Reader<AsnModel>!
  private var reader: Reader<AsnModel> { get { return AsnLookupTest.reader } }

  override static func setUp() {
    super.setUp()
    setupReader()
  }

  private static func setupReader() {
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

  func testInitialization() { measure { AsnLookupTest.setupReader() } }

  func testLookup_1() { measure { reader.lookup(.v4(80, 99, 18, 166)) } }

  func testLookup_2() { measure { reader.lookup(.v6("::1.128.0.0")) } }

  func testLookup_3() { measure { reader.lookup(.v6("::12.81.92.0")) } }

  func testLookup_4() { measure { reader.lookup(.v6("::12.81.96.0")) } }

  func testLookup_5() { measure { reader.lookup(.v6("2600:6000::")) } }

  func testLookup_6() { measure { reader.lookup(.v6("2600:7000::")) } }

  func testLookup_7() { measure { reader.lookup(.v6("2600:7100::")) } }

}
