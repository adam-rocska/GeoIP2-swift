import Foundation
import protocol DBReader.Reader

public class CityFileBased {

  static let databaseType = DatabaseType.city

  let dbReader: DBReader.Reader
  public var metadata: DbMetadata { get { return dbReader.metadata } }

  public init(dbReader: Reader) {
    // php scripter style validation. Dumb as a rock, but that's what MaxMind implemented, and therefore expects.
    precondition(dbReader.metadata.databaseType.contains(CityFileBased.databaseType.rawValue))
    self.dbReader = dbReader
  }

  public func lookup(_ ip: IpAddress) -> CityModel? {
    guard let dictionary = dbReader.get(ip) else { return nil }
//    print(dictionary)
    let model = CityModel(dictionary)
    print(model)
//    ["location": Decoder.Payload.map(
//      ["time_zone": Decoder.Payload.utf8String("Europe/Budapest"),
//       "longitude": Decoder.Payload.double(19.0404),
//       "latitude": Decoder.Payload.double(47.4984),
//       "accuracy_radius": Decoder.Payload.uInt16(20)]
//    ),
//      "continent": Decoder.Payload.map(
//        ["geoname_id": Decoder.Payload.uInt32(6255148),
//         "code": Decoder.Payload.utf8String("EU"),
//         "names": Decoder.Payload.map(
//           [
//             "es": Decoder.Payload.utf8String("Europa"),
//             "fr": Decoder.Payload.utf8String("Europe"),
//             "ru": Decoder.Payload.utf8String("Европа"),
//             "pt-BR": Decoder.Payload.utf8String("Europa"),
//             "ja": Decoder.Payload.utf8String("ヨーロッパ"),
//             "zh-CN": Decoder.Payload.utf8String("欧洲"),
//             "de": Decoder.Payload.utf8String("Europa"),
//             "en": Decoder.Payload.utf8String("Europe")
//           ]
//         )]
//      ),
//      "country": Decoder.Payload.map(
//        ["names": Decoder.Payload.map(
//          ["es": Decoder.Payload.utf8String("Hungría"),
//           "ja": Decoder.Payload.utf8String(
//             "ハンガリー共和国"
//           ),
//           "en": Decoder.Payload.utf8String("Hungary"),
//           "ru": Decoder.Payload.utf8String(
//             "Венгрия"
//           ),
//           "pt-BR": Decoder.Payload.utf8String("Hungria"),
//           "zh-CN": Decoder.Payload.utf8String(
//             "匈牙利"
//           ),
//           "de": Decoder.Payload.utf8String("Ungarn"),
//           "fr": Decoder.Payload.utf8String("Hongrie")]
//        ),
//          "is_in_european_union": Decoder.Payload.boolean(true),
//          "iso_code": Decoder.Payload.utf8String(
//            "HU"
//          ),
//          "geoname_id": Decoder.Payload.uInt32(719819)]
//      ),
//      "subdivisions": Decoder.Payload.array(
//        [Decoder.Payload.map(
//          ["geoname_id": Decoder.Payload.uInt32(3054638),
//           "iso_code": Decoder.Payload.utf8String(
//             "BU"
//           ),
//           "names": Decoder.Payload.map(["en": Decoder.Payload.utf8String("Budapest")])]
//        )]
//      ),
//      "city": Decoder.Payload.map(
//        ["geoname_id": Decoder.Payload.uInt32(3054643),
//         "names": Decoder.Payload.map(
//           ["ja": Decoder.Payload.utf8String("ブダペスト"),
//            "es": Decoder.Payload.utf8String(
//              "Budapest"
//            ),
//            "ru": Decoder.Payload.utf8String("Будапешт"),
//            "de": Decoder.Payload.utf8String(
//              "Budapest"
//            ),
//            "en": Decoder.Payload.utf8String("Budapest"),
//            "fr": Decoder.Payload.utf8String(
//              "Budapest"
//            ),
//            "zh-CN": Decoder.Payload.utf8String("布达佩斯"),
//            "pt-BR": Decoder.Payload.utf8String("Budapeste")]
//         )]
//      ),
//      "registered_country": Decoder.Payload.map(
//        ["geoname_id": Decoder.Payload.uInt32(719819),
//         "is_in_european_union": Decoder.Payload.boolean(
//           true
//         ),
//         "iso_code": Decoder.Payload.utf8String("HU"),
//         "names": Decoder.Payload.map(
//           ["de": Decoder.Payload.utf8String("Ungarn"),
//            "zh-CN": Decoder.Payload.utf8String(
//              "匈牙利"
//            ),
//            "fr": Decoder.Payload.utf8String("Hongrie"),
//            "ru": Decoder.Payload.utf8String(
//              "Венгрия"
//            ),
//            "pt-BR": Decoder.Payload.utf8String("Hungria"),
//            "en": Decoder.Payload.utf8String(
//              "Hungary"
//            ),
//            "es": Decoder.Payload.utf8String("Hungría"),
//            "ja": Decoder.Payload.utf8String("ハンガリー共和国")]
//         )]
//      ),
//      "postal": Decoder.Payload.map(["code": Decoder.Payload.utf8String("1096")])]



//    CityModel(
//      city: CityRecord(
//        confidence: <#T##Int?##Swift.Int?#>,
//        geonameId: <#T##Int?##Swift.Int?#>,
//        name: <#T##String?##Swift.String?#>,
//        names: <#T##[String: String]?##[Swift.String: Swift.String]?#>
//      ),
//      location: LocationRecord(
//        averageIncome: <#T##Int?##Swift.Int?#>,
//        accuracyRadius: <#T##Int?##Swift.Int?#>,
//        latitude: <#T##Float?##Swift.Float?#>,
//        longitude: <#T##Float?##Swift.Float?#>,
//        populationDensity: <#T##Int?##Swift.Int?#>,
//        metroCode: <#T##Int?##Swift.Int?#>,
//        timeZone: <#T##String?##Swift.String?#>
//      ),
//      postal: PostalRecord(code: <#T##String?##Swift.String?#>,
//    confidence: <#T##Int?##Swift.Int?#>),
//      mostSpecificSubdivision: SubdivisionRecord(
//        confidence: <#T##Int?##Swift.Int?#>,
//        geonameId: <#T##Int?##Swift.Int?#>,
//        isoCode: <#T##String?##Swift.String?#>,
//        name: <#T##String?##Swift.String?#>,
//        names: <#T##[String: String]?##[Swift.String: Swift.String]?#>
//      )
//    )
    return nil
  }
}
