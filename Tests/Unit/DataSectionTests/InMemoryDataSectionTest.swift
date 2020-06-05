import Foundation
import XCTest
import TestResources
import class MetadataReader.Reader
import Decoder
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
      decoder: Decoder(Data([0b0000_0000]))
    )
    XCTAssertNil(dataSection.lookup(pointer: 100))
  }

  func testLookup_returnsNilIfIteratorDoesntResolveToMap() {
    let dataSection = InMemoryDataSection(
      metadata: InMemoryDataSectionTest.countryMetadata,
      decoder: Decoder(Data(
        [0b0101_1100] + "Hello World Hello World test".data(using: .utf8)!
      ))
    )
    XCTAssertNil(dataSection.lookup(pointer: 0))
  }

  func testLookup_returnsExpectedDictionary() {
    let dataSection    = InMemoryDataSection(
      metadata: InMemoryDataSectionTest.countryMetadata,
      stream: InputStream(fileAtPath: InMemoryDataSectionTest.countryFilePath)!
    )
    let expectedResult = [
      "continent": Payload.map(
        [
          "geoname_id": Payload.uInt32(6255148),
          "names": Payload.map(
            [
              "ru": Payload.utf8String("Европа"),
              "en": Payload.utf8String("Europe"),
              "de": Payload.utf8String("Europa"),
              "fr": Payload.utf8String("Europe"),
              "ja": Payload.utf8String("ヨーロッパ"),
              "pt-BR": Payload.utf8String("Europa"),
              "es": Payload.utf8String("Europa"),
              "zh-CN": Payload.utf8String("欧洲")]
          ),
          "code": Payload.utf8String("EU")
        ]
      ),
      "country": Payload.map(
        [
          "names": Payload.map(
            [
              "es": Payload.utf8String("Hungría"),
              "zh-CN": Payload.utf8String("匈牙利"),
              "ru": Payload.utf8String("Венгрия"),
              "ja": Payload.utf8String("ハンガリー共和国"),
              "de": Payload.utf8String("Ungarn"),
              "fr": Payload.utf8String("Hongrie"),
              "pt-BR": Payload.utf8String("Hungria"),
              "en": Payload.utf8String("Hungary")]
          ),
          "iso_code": Payload.utf8String("HU"),
          "is_in_european_union": Payload.boolean(true),
          "geoname_id": Payload.uInt32(719819)]
      ),
      "registered_country": Payload.map(
        [
          "is_in_european_union": Payload.boolean(true),
          "names": Payload.map(
            [
              "es": Payload.utf8String("Hungría"),
              "de": Payload.utf8String("Ungarn"),
              "fr": Payload.utf8String("Hongrie"),
              "en": Payload.utf8String("Hungary"),
              "pt-BR": Payload.utf8String("Hungria"),
              "ja": Payload.utf8String("ハンガリー共和国"),
              "ru": Payload.utf8String("Венгрия"),
              "zh-CN": Payload.utf8String("匈牙利")]
          ),
          "geoname_id": Payload.uInt32(719819),
          "iso_code": Payload.utf8String("HU")
        ]
      )
    ]

    XCTAssertEqual(expectedResult, dataSection.lookup(pointer: 9696))
  }

}
