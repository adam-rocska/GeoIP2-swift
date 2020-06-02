import Foundation
import enum Decoder.Payload

public struct PostalRecord {
  let code:       String?
  // assumed
  let confidence: UInt8?

  public init(code: String?, confidence: UInt8?) {
    self.code = code
    self.confidence = confidence
  }

  init(_ dictionary: [String: Payload]?) {
    self.init(
      code: dictionary?["code"]?.unwrap(),
      confidence: dictionary?["confidence"]?.unwrap()
    )
  }
}
