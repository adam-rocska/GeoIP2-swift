import Foundation
import enum Decoder.Payload

public struct ContinentRecord {
  let code:      String?
  let geonameId: UInt32?
  let names:     [String: String]?
  var name:      String? { get { return names?["en"] } }

  public init(code: String?, geonameId: UInt32?, names: [String: String]?) {
    self.code = code
    self.geonameId = geonameId
    self.names = names
  }

  init(_ dictionary: [String: Payload]?) {
    self.init(
      code: dictionary?["code"]?.unwrap(),
      geonameId: dictionary?["geoname_id"]?.unwrap(),
      names: (dictionary?["names"]?.unwrap() ?? [:] as [String: Payload]).compactMapValues({ $0.unwrap() })
    )
  }
}
