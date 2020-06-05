import Foundation
import XCTest
import TestResources
extension XCTestCase {

  private static var countryFilePath: String {
    get {
      guard let countryFilePath = bundle.path(
        forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
        ofType: "mmdb"
      ) else { fatalError("GeoLite2 Country DB file was not found.") }
      return countryFilePath
    }
  }

  private static var cityFilePath: String {
    get {
      guard let countryFilePath = bundle.path(
        forResource: "GeoLite2-City_20200526/GeoLite2-City",
        ofType: "mmdb"
      ) else { fatalError("GeoLite2 Country DB file was not found.") }
      return countryFilePath
    }
  }

  private static var asnFilePath: String {
    get {
      guard let countryFilePath = bundle.path(
        forResource: "GeoLite2-ASN_20200526/GeoLite2-ASN",
        ofType: "mmdb"
      ) else { fatalError("GeoLite2 Country DB file was not found.") }
      return countryFilePath
    }
  }

}
