import Foundation
import enum Decoder.Payload

public struct MaxMindRecord {
  // assumed
  let queriesRemaining: UInt16?
}

extension MaxMindRecord: DictionaryInitialisable {
  public init(_ dictionary: [String: Payload]?) {
    self.init(queriesRemaining: dictionary?["queries_remaining"]?.unwrap())
  }
}