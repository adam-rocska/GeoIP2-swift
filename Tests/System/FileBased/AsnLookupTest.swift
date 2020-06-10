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
    XCTAssertEqual(
      AsnModel(
        autonomousSystemNumber: 6830,
        autonomousSystemOrganization: "Liberty Global B.V.",
        ipAddress: .v4(80, 99, 18, 166),
        netmask: IpAddress.v4Netmask(ofBitLength: 15)
      ),
      reader.lookup(.v4(80, 99, 18, 166))
    )
    XCTAssertEqual(
      AsnModel(
        autonomousSystemNumber: 1221,
        autonomousSystemOrganization: "Telstra Corporation Ltd",
        ipAddress: .v6("::1.128.0.0"),
        netmask: IpAddress.v6Netmask(ofBitLength: 107)
      ),
      reader.lookup(.v6("::1.128.0.0"))
    )
    XCTAssertEqual(
      AsnModel(
        autonomousSystemNumber: 7018,
        autonomousSystemOrganization: "ATT-INTERNET4",
        ipAddress: .v6("::12.81.92.0"),
        netmask: IpAddress.v6Netmask(ofBitLength: 118)
      ),
      reader.lookup(.v6("::12.81.92.0"))
    )
    XCTAssertEqual(
      AsnModel(
        autonomousSystemNumber: 7018,
        autonomousSystemOrganization: "ATT-INTERNET4",
        ipAddress: .v6("::12.81.96.0"),
        netmask: IpAddress.v6Netmask(ofBitLength: 116)
      ),
      reader.lookup(.v6("::12.81.96.0"))
    )
    XCTAssertEqual(
      AsnModel(
        autonomousSystemNumber: 12271,
        autonomousSystemOrganization: "TWC-12271-NYC",
        ipAddress: .v6("2600:6000::"),
        netmask: IpAddress.v6Netmask(ofBitLength: 33)
      ),
      reader.lookup(.v6("2600:6000::"))
    )
    XCTAssertEqual(
      AsnModel(
        autonomousSystemNumber: 6939,
        autonomousSystemOrganization: "HURRICANE",
        ipAddress: .v6("2600:7000::"),
        netmask: IpAddress.v6Netmask(ofBitLength: 24)
      ),
      reader.lookup(.v6("2600:7000::"))
    )
    XCTAssertNil(reader.lookup(.v6("2600:7100::")))
  }

}
