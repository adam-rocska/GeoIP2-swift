import Foundation
import enum Decoder.Payload

public struct RepresentedCountryRecord {
  let type: String?
}

extension RepresentedCountryRecord: DictionaryInitialisable {
  public init(_ dictionary: [String: Payload]?) {
    self.init(type: dictionary?["type"]?.unwrap())
  }
}