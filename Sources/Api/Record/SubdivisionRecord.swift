import Foundation
import enum Decoder.Payload

public struct SubdivisionRecord: Equatable {
  // Assumed
  let confidence: UInt8?
  let geonameId:  UInt32?
  let isoCode:    String?
  let names:      [String: String]?
  var name:       String? { get { return names?["en"] } }
}

extension SubdivisionRecord: DictionaryInitialisableRecord {
  public init(_ dictionary: [String: Payload]?) {
    self.init(
      confidence: dictionary?["confidence"]?.unwrap(),
      geonameId: dictionary?["geoname_id"]?.unwrap(),
      isoCode: dictionary?["iso_code"]?.unwrap(),
      names: (dictionary?["names"]?.unwrap() ?? [:] as [String: Payload]).compactMapValues({ $0.unwrap() })
    )
  }
}