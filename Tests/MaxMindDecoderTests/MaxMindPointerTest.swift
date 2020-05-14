import Foundation
import XCTest
@testable import MaxMindDecoder

class MaxMindPointerTest: XCTestCase {
  func testConvertibility() {
    let strideStep = UInt32.max / 15
    var value      = UInt32.min
    while value < UInt32.max {
      XCTAssertEqual(value, UInt32(MaxMindPointer(value)))
      value += strideStep
    }
  }
}
