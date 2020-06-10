import Foundation
import enum Decoder.Payload

public struct PostalRecord: Equatable {
  let code:       String?
  // assumed
  let confidence: UInt8?
}

extension PostalRecord: DictionaryInitialisableRecord {
  public init(_ dictionary: [String: Payload]?) {
    self.init(
      code: dictionary?["code"]?.unwrap(),
      confidence: dictionary?["confidence"]?.unwrap()
    )
  }
}