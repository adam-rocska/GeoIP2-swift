import Foundation
import XCTest
@testable import Decoder

class DataTypeTest: XCTestCase {

  func testIsExtendedType() {
    for dataType in DataType.allCases {
      if dataType.rawValue < 8 {
        XCTAssertFalse(dataType.isExtendedType, "\(dataType) is not an extended type.")
      } else {
        XCTAssertTrue(dataType.isExtendedType, "\(dataType) is an extended type.")
      }
    }
  }

}
