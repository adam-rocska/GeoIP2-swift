import Foundation
import XCTest
@testable import MaxMindDBReader

class ControlByteTest: XCTestCase {
  func testInit() {
    let dataTypes = (1...255).compactMap({ DataType(rawValue: $0) })

    let nonExtendedTypes = dataTypes.filter({ $0.rawValue <= 7 }).map({ $0.rawValue })
    let extendedTypes = dataTypes.filter({ $0.rawValue > 7 }).map({ $0.rawValue })
    precondition(nonExtendedTypes.count > 0, "nonExtendedTypes can't be empty.")
    precondition(extendedTypes.count > 0, "extendedTypes can't be empty.")
    for nonExtendedType in nonExtendedTypes {
      XCTAssertEqual(
        DataType(rawValue: nonExtendedType),
        ControlByte(firstByte: nonExtendedType &<< 5)?.type
      )
      XCTAssertEqual(
        DataType(rawValue: nonExtendedType),
        ControlByte(
          firstByte: nonExtendedType &<< 5,
          secondByte: 0b1111_1111
        )?.type
      )
    }
    for extendedType in extendedTypes {
      XCTAssertEqual(
        DataType(rawValue: extendedType),
        ControlByte(firstByte: 0b0000_0000, secondByte: extendedType - 7)?.type
      )
    }
  }
}
