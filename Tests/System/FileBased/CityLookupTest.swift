import Foundation
import XCTest
import TestResources
import class Api.Reader
import class Api.ReaderFactory
import enum Api.IpAddress
@testable import struct Api.CityModel
@testable import struct Api.CityRecord
@testable import struct Api.ContinentRecord
@testable import struct Api.CountryRecord
@testable import struct Api.LocationRecord
@testable import struct Api.MaxMindRecord
@testable import struct Api.PostalRecord
@testable import struct Api.RepresentedCountryRecord
@testable import struct Api.SubdivisionRecord
@testable import struct Api.TraitsRecord

class CityLookupTest: XCTestCase {

  private static var reader: Reader<CityModel>!
  private var reader: Reader<CityModel> { get { return CityLookupTest.reader } }

  override static func setUp() {
    super.setUp()
    let factory = ReaderFactory()
    guard let url = bundle.url(
      forResource: "GeoLite2-City",
      withExtension: "mmdb",
      subdirectory: "GeoLite2-City_20200526"
    ) else {
      XCTFail("Could not load country database.")
      return
    }

    do {
      try reader = factory.makeReader(source: url, type: .city)
    } catch {
      XCTFail("Couldn't initialize reader.")
    }
  }

  func testSuccessfulLookup() {
    XCTAssertEqual(
      CityModel(
        city: CityRecord(
          confidence: nil,
          geonameId: 3054643,
          names: [
            "de": "Budapest",
            "en": "Budapest",
            "es": "Budapest",
            "fr": "Budapest",
            "ja": "ブダペスト",
            "pt-BR": "Budapeste",
            "ru": "Будапешт",
            "zh-CN": "布达佩斯"
          ]
        ),
        location: LocationRecord(
          averageIncome: nil,
          accuracyRadius: 20,
          latitude: 47.4984,
          longitude: 19.0404,
          populationDensity: nil,
          metroCode: nil,
          timeZone: "Europe/Budapest"
        ),
        postal: PostalRecord(code: "1096", confidence: nil),
        subdivisions: [
          SubdivisionRecord(
            confidence: nil,
            geonameId: 3054638,
            isoCode: "BU",
            names: ["en": "Budapest"]
          )
        ],
        continent: ContinentRecord(
          code: "EU",
          geonameId: 6255148,
          names: [
            "de": "Europa",
            "en": "Europe",
            "es": "Europa",
            "fr": "Europe",
            "ja": "ヨーロッパ",
            "pt-BR": "Europa",
            "ru": "Европа",
            "zh-CN": "欧洲"
          ]
        ),
        country: CountryRecord(
          confidence: nil,
          geonameId: 719819,
          isInEuropeanUnion: true,
          isoCode: "HU",
          names: [
            "de": "Ungarn",
            "en": "Hungary",
            "es": "Hungría",
            "fr": "Hongrie",
            "ja": "ハンガリー共和国",
            "pt-BR": "Hungria",
            "ru": "Венгрия",
            "zh-CN": "匈牙利"
          ]
        ),
        maxmind: MaxMindRecord(queriesRemaining: nil),
        registeredCountry: CountryRecord(
          confidence: nil,
          geonameId: 719819,
          isInEuropeanUnion: true,
          isoCode: "HU",
          names: [
            "de": "Ungarn",
            "en": "Hungary",
            "es": "Hungría",
            "fr": "Hongrie",
            "ja": "ハンガリー共和国",
            "pt-BR": "Hungria",
            "ru": "Венгрия",
            "zh-CN": "匈牙利"
          ]
        ),
        representedCountry: RepresentedCountryRecord(type: nil),
        traits: TraitsRecord(
          autonomousSystemNumber: nil,
          autonomousSystemOrganization: nil,
          connectionType: nil,
          domain: nil,
          isAnonymous: false,
          isAnonymousProxy: false,
          isAnonymousVpn: false,
          isHostingProvider: false,
          isLegitimateProxy: false,
          isPublicProxy: false,
          isSatelliteProvider: false,
          isTorExitNode: false,
          isp: nil,
          organization: nil,
          staticIPScore: nil,
          userCount: nil,
          userType: nil
        ),
        ipAddress: .v4(80, 99, 18, 166),
        netmask: IpAddress.v4Netmask(ofBitLength: 26)
      ),
      reader.lookup(.v4(80, 99, 18, 166))
    )

    XCTAssertEqual(
      CityModel(
        city: CityRecord(confidence: nil, geonameId: nil, names: [:]),
        location: LocationRecord(
          averageIncome: nil,
          accuracyRadius: 1000,
          latitude: -33.494,
          longitude: 143.2104,
          populationDensity: nil,
          metroCode: nil,
          timeZone: "Australia/Sydney"
        ),
        postal: PostalRecord(code: nil, confidence: nil),
        subdivisions: [],
        continent: ContinentRecord(
          code: "OC",
          geonameId: 6255151,
          names: [
            "de": "Ozeanien",
            "en": "Oceania",
            "es": "Oceanía",
            "fr": "Océanie",
            "ja": "オセアニア",
            "pt-BR": "Oceania",
            "ru": "Океания",
            "zh-CN": "大洋洲"
          ]
        ),
        country: CountryRecord(
          confidence: nil,
          geonameId: 2077456,
          isInEuropeanUnion: false,
          isoCode: "AU",
          names: [
            "de": "Australien",
            "en": "Australia",
            "es": "Australia",
            "fr": "Australie",
            "ja": "オーストラリア",
            "pt-BR": "Austrália",
            "ru": "Австралия",
            "zh-CN": "澳大利亚"
          ]
        ),
        maxmind: MaxMindRecord(queriesRemaining: nil),
        registeredCountry: CountryRecord(
          confidence: nil,
          geonameId: 2077456,
          isInEuropeanUnion: false,
          isoCode: "AU",
          names: [
            "de": "Australien",
            "en": "Australia",
            "es": "Australia",
            "fr": "Australie",
            "ja": "オーストラリア",
            "pt-BR": "Austrália",
            "ru": "Австралия",
            "zh-CN": "澳大利亚"
          ]
        ),
        representedCountry: RepresentedCountryRecord(type: nil),
        traits: TraitsRecord(
          autonomousSystemNumber: nil,
          autonomousSystemOrganization: nil,
          connectionType: nil,
          domain: nil,
          isAnonymous: false,
          isAnonymousProxy: false,
          isAnonymousVpn: false,
          isHostingProvider: false,
          isLegitimateProxy: false,
          isPublicProxy: false,
          isSatelliteProvider: false,
          isTorExitNode: false,
          isp: nil,
          organization: nil,
          staticIPScore: nil,
          userCount: nil,
          userType: nil
        ),
        ipAddress: .v6("::1.128.0.0"),
        netmask: IpAddress.v6Netmask(ofBitLength: 114)
      ),
      reader.lookup(.v6("::1.128.0.0"))
    )

    XCTAssertNil(reader.lookup(.v6("2600:7100::")))
  }

}
