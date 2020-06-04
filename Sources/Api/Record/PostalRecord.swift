import Foundation
import enum Decoder.Payload

public struct PostalRecord {
  let code:       String?
  // assumed
  let confidence: UInt8?
}

extension PostalRecord: DictionaryInitialisable {
  public init(_ dictionary: [String: Payload]?) {
    self.init(
      code: dictionary?["code"]?.unwrap(),
      confidence: dictionary?["confidence"]?.unwrap()
    )
  }
}