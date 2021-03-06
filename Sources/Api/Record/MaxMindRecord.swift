import Foundation
import enum Decoder.Payload

public struct MaxMindRecord: Equatable {
  // assumed
  let queriesRemaining: UInt16?
}

extension MaxMindRecord: DictionaryInitialisableRecord {
  public init(_ dictionary: [String: Payload]?) {
    self.init(queriesRemaining: dictionary?["queries_remaining"]?.unwrap())
  }
}