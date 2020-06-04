import Foundation
import enum Decoder.Payload

public struct SubdivisionRecord {
  // Assumed
  let confidence: UInt8?
  let geonameId:  UInt32?
  let isoCode:    String?
  let names:      [String: String]?
  var name:       String? { get { return names?["en"] } }
}

extension SubdivisionRecord: DictionaryInitialisable {
  public init(_ dictionary: [String: Payload]?) {
    self.init(
      confidence: dictionary?["confidence"]?.unwrap(),
      geonameId: dictionary?["geoname_id"]?.unwrap(),
      isoCode: dictionary?["iso_cod"]?.unwrap(),
      names: (dictionary?["names"]?.unwrap() ?? [:] as [String: Payload]).compactMapValues({ $0.unwrap() })
    )
  }
}