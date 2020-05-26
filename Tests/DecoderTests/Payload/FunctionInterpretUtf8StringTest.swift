import Foundation
import XCTest
@testable import Decoder

class FunctionInterpretUtf8StringTest: XCTestCase {
  func testInterpretUtf8String() {
    let testStrings = [
      "test",
      "hello world",
      "scripters should never design binary file formats"
    ]
    for testString in testStrings {
      guard let payload = interpretUtf8String(bytes: Data(testString)) else {
        XCTFail("Should have been able to interpret input bytes.")
        continue
      }
      switch payload {
        case .utf8String(let decodedString):
          XCTAssertEqual(testString, decodedString)
        default:
          XCTFail("Should have represented input as a string.")
      }
    }
  }
}
