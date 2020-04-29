import Foundation
import XCTest
@testable import MaxMindDBReader

class DecoderTest: XCTestCase {
  func testFasz() {
    guard let inputStream = InputStream(
      fileAtPath: "/Users/rocskaadam/src/adam-rocska/src/GeoIP2-swift/Tests/MaxMindDBReaderTests/GeoLite2-Country.mmdb"
    ) else {
      XCTFail("Bazmeg")
      return
    }

    let data   = Data(inputStream: inputStream)
    let idx    = data.index(of: Reader.metadataStartMarker)
    print(idx)
  }
}
