import Foundation
import XCTest
import Metadata
import MaxMindDecoder
@testable import DataSection

class InMemoryDataSectionTest: XCTestCase {

  private static var countryFilePath: String {
    get {
      guard let countryFilePath = bundle.path(
        forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
        ofType: "mmdb"
      ) else { fatalError("GeoLite2 Country DB file was not found.") }
      return countryFilePath
    }
  }

  private static let countryMetadata = Reader(windowSize: 1024).read(
    InputStream(fileAtPath: countryFilePath)!
  )!

  func testLookup_returnsNilIfIteratorCantResolveNextControlByte() {
    let dataSection = InMemoryDataSection(
      metadata: InMemoryDataSectionTest.countryMetadata,
      iterator: MaxMindIterator(Data([0b0000_0000]))!,
      decoder: MaxMindDecoder(inputEndianness: .big)
    )
    XCTAssertNil(dataSection.lookup(pointer: 100))
  }

  func testLookup_returnsNilIfIteratorDoesntResolveToMap() {
    let dataSection = InMemoryDataSection(
      metadata: InMemoryDataSectionTest.countryMetadata,
      iterator: MaxMindIterator(
        Data(
          [0b0101_1100] + "Hello World Hello World test".data(using: .utf8)!
        )
      )!,
      decoder: MaxMindDecoder(inputEndianness: .big)
    )
    XCTAssertNil(dataSection.lookup(pointer: 0))
  }

  func testLookup_returnsExpectedDictionary() {
    let dataSection = InMemoryDataSection(
      metadata: InMemoryDataSectionTest.countryMetadata,
      stream: InputStream(fileAtPath: InMemoryDataSectionTest.countryFilePath)!
    )
    print(dataSection.lookup(pointer: 9696))
  }

}
