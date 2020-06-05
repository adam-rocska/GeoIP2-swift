import Foundation
import XCTest
import TestResources
@testable import Decoder

class StringTest: XCTestCase {

  func testInit_fromData() {
    let testStrings = [
      "Hello World",
      "Some test string",
      "Another Test STRING"
    ]
    for testString in testStrings {
      let binary = Data(testString.utf8)
      XCTAssertEqual(testString, String(binary), "Binary should have been decoded as \(testString)")
    }
  }

}
