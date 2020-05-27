import Foundation

func interpretArray(
  entryCount: UInt32,
  decoder: Decoder,
  payloadStart: Data.Index,
  resolvePointers: Bool
) -> (Payload, UInt32)? {
  var result: [Payload]  = []
  var payloadIndexToRead = payloadStart
  for _ in 1...entryCount {
    guard let output: Decoder.Output = decoder.read(at: payloadIndexToRead, resolvePointers: resolvePointers) else {
      return nil
    }
    payloadIndexToRead = output.payloadRange.upperBound
    result.append(output.payload)
  }

  return (Payload.array(result), UInt32(payloadIndexToRead - payloadStart))
}
