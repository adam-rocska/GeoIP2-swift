import Foundation
import XCTest
import GeoIP2

class GeoIP2Tests: XCTestCase {

  lazy var database: GeoIP2 = {
    guard let countryFilePath = bundle.path(
      forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
      ofType: "mmdb"
    ) else {
      fatalError("GeoLite2 Country DB file was not found.")
    }

    guard let geoIp2 = GeoIP2(countryFilePath) else {
      fatalError("GeoIP2 database couldn't initialize.")
    }

    return geoIp2
  }()

  func testExample() {
    XCTAssertEqual(database.lookup("202.108.22.220")?.isoCode, "CN")
    XCTAssertEqual(database.lookup("8.8.8.8")?.isoCode, "US")
    XCTAssertEqual(database.lookup("8.8.4.4")?.isoCode, "US")

    XCTAssertNotNil(database.lookup(IPOfHost("youtube.com")!))
    XCTAssertNotNil(database.lookup(IPOfHost("facebook.com")!))
    XCTAssertNotNil(database.lookup(IPOfHost("twitter.com")!))
    XCTAssertNotNil(database.lookup(IPOfHost("instagram.com")!))
    XCTAssertNotNil(database.lookup(IPOfHost("google.com")!))
  }

  func testCloudFlare() {
    let lookup = database.lookup("1.1.1.1")
    XCTAssertNotNil(lookup)
  }
}

// See http://stackoverflow.com/questions/25890533/how-can-i-get-a-real-ip-address-from-dns-query-in-swift
func IPOfHost(_ host: String) -> String? {
  let host = CFHostCreateWithName(nil, host as CFString).takeRetainedValue()
  CFHostStartInfoResolution(host, .addresses, nil)
  var success = DarwinBoolean(false)
  guard let addressing = CFHostGetAddressing(host, &success) else {
    return nil
  }

  let addresses = addressing.takeUnretainedValue() as NSArray
  if addresses.count > 0 {
    let theAddress = addresses[0] as! Data
    var hostname   = [CChar](repeating: 0, count: Int(NI_MAXHOST))
    let infoResult = getnameinfo(
      (theAddress as NSData).bytes.bindMemory(to: sockaddr.self, capacity: theAddress.count),
      socklen_t(theAddress.count),
      &hostname,
      socklen_t(hostname.count),
      nil,
      0,
      NI_NUMERICHOST
    )
    if infoResult == 0 {
      if let numAddress = String(validatingUTF8: hostname) {
        return numAddress
      }
    }
  }

  return nil
}