import Foundation
import enum Decoder.Payload

public struct RepresentedCountryRecord: Equatable {
  let type: String?
}

extension RepresentedCountryRecord: DictionaryInitialisableRecord {
  public init(_ dictionary: [String: Payload]?) {
    self.init(type: dictionary?["type"]?.unwrap())
  }
}