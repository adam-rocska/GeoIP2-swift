import Foundation

func interpretMap(
  entryCount: UInt32,
  decoder: Decoder,
  payloadStart: Data.Index,
  resolvePointers: Bool
) -> (Payload, UInt32)? {
  var result             = [String: Payload]()
  var payloadIndexToRead = payloadStart

  for _ in 1...entryCount {
    guard let keyCandidate: Decoder.Output = decoder.read(
      at: payloadIndexToRead,
      resolvePointers: resolvePointers
    ) else {
      return nil
    }

    guard case Payload.utf8String(let key) = keyCandidate.payload else { return nil }
    payloadIndexToRead = keyCandidate.payloadRange.upperBound

    guard let valueCandidate: Decoder.Output = decoder.read(
      at: payloadIndexToRead,
      resolvePointers: resolvePointers
    ) else {
      return nil
    }
    result[key] = valueCandidate.payload
    payloadIndexToRead = valueCandidate.payloadRange.upperBound
  }

  return (Payload.map(result), UInt32(payloadIndexToRead - payloadStart))
}