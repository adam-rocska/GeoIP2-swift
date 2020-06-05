import Foundation
import XCTest
import TestResources

class Wut: XCTestCase {

  func testWut() {
    print(bundle.path(
      forResource: "GeoLite2-ASN_20200526/GeoLite2-ASN",
      ofType: "mmdb"
    ))
//    print(Bundle.main.bundlePath)
//    print(Bundle.main.resourcePath)
//    print(Bundle.main.privateFrameworksPath)
//    print(Bundle.main.builtInPlugInsPath)
//    print(Bundle.main.executablePath)
//    print(Bundle.main.sharedFrameworksPath)
//    print(Bundle.main.sharedSupportPath)
//    XCTAssertTrue(false)
//    let bundle = Bundle(for: Wut.self)
//    bundle.path(forResource: <#T##String?##Swift.String?#>, ofType: <#T##String?##Swift.String?#>)
//    print(bundle)
  }

}
