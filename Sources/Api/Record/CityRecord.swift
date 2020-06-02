import Foundation
import enum Decoder.Payload

public struct CityRecord {
  // assumed
  let confidence: UInt8?
  let geonameId:  UInt32?
  let names:      [String: String]?
  var name:       String? { get { return names?["en"] } }

  public init(confidence: UInt8?, geonameId: UInt32?, names: [String: String]?) {
    self.confidence = confidence
    self.geonameId = geonameId
    self.names = names
  }

  init(_ dictionary: [String: Payload]?) {
    self.init(
      confidence: dictionary?["confidence"]?.unwrap(),
      geonameId:  dictionary?["geoname_id"]?.unwrap(),
      names: (dictionary?["names"]?.unwrap() ?? [:] as [String: Payload]).compactMapValues({ $0.unwrap() })
    )
  }
}
