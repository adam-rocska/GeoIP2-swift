import Foundation
import XCTest
@testable import MaxMindDBReader

class InitializeWithInputStreamTest: XCTestCase {
  func testInitFromInputStream() {
    // just a casual bigass string. We'de need better tests here.
    let stringData = String(repeating: "Some test string", count: 1024).data(using: .ascii)!
    let stream     = InputStream(data: stringData)
    XCTAssertEqual(stringData, Data(inputStream: stream))
  }
}
