import Foundation
import XCTest
@testable import MaxMindDecoder

class MaxMindPointerTest: XCTestCase {
  func testConvertibility_UInt32() {
    let strideStep = UInt32.max / 15
    var value      = UInt32.min
    while value < UInt32.max {
      XCTAssertEqual(value, UInt32(MaxMindPointer(value)))
      value += strideStep
    }
  }

  func testConvertibility_Int() {
    let strideStep = UInt32.max / 15
    var value      = UInt32.min
    while value < UInt32.max {
      XCTAssertEqual(Int(value), Int(MaxMindPointer(value)))
      value += strideStep
    }
  }
}
