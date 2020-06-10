import Foundation
import enum Decoder.Payload

public struct CityRecord: Equatable {
  // assumed
  let confidence: UInt8?
  let geonameId:  UInt32?
  let names:      [String: String]?
  var name:       String? { get { return names?["en"] } }
}

extension CityRecord: DictionaryInitialisableRecord {
  public init(_ dictionary: [String: Payload]?) {
    self.init(
      confidence: dictionary?["confidence"]?.unwrap(),
      geonameId:  dictionary?["geoname_id"]?.unwrap(),
      names: (dictionary?["names"]?.unwrap() ?? [:] as [String: Payload]).compactMapValues({ $0.unwrap() })
    )
  }
}