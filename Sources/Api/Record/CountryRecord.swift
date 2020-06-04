import Foundation
import enum Decoder.Payload

public struct CountryRecord {
  let confidence:        UInt8?
  let geonameId:         UInt32?
  let isInEuropeanUnion: Bool
  let isoCode:           String?
  let names:             [String: String]?
  var name:              String? { get { return names?["en"] } }
}

extension CountryRecord: DictionaryInitialisable {
  public init(_ dictionary: [String: Payload]?) {
    self.init(
      confidence: dictionary?["confidence"]?.unwrap(),
      geonameId: dictionary?["geoname_id"]?.unwrap(),
      isInEuropeanUnion: dictionary?["is_in_european_union"]?.unwrap() ?? false,
      isoCode: dictionary?["iso_code"]?.unwrap(),
      names: (dictionary?["names"]?.unwrap() ?? [:] as [String: Payload]).compactMapValues({ $0.unwrap() })
    )
  }
}