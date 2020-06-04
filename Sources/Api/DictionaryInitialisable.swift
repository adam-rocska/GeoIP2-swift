import Foundation
import enum Decoder.Payload

public protocol DictionaryInitialisable {
  init(_ dictionary: [String: Payload]?)
}
