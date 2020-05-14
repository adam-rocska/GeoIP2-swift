import Foundation
import XCTest
@testable import MaxMindDecoder

class MaxMindPointerTest: XCTestCase {
  func testConvertibility() {
    let strideStep = UInt.max / 15
    var value      = UInt.min
    while value < UInt.max {
      XCTAssertEqual(value, UInt(MaxMindPointer(value)))
      value += strideStep
    }
  }
}
