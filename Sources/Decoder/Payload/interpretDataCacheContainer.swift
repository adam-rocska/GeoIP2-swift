import Foundation

func interpretDataCacheContainer(
  entryCount: UInt32,
  decoder: Decoder,
  payloadStart: Data.Index,
  resolvePointers: Bool
) -> Payload? {
  var result: [Payload]  = []
  var payloadIndexToRead = payloadStart
  for _ in 1...entryCount {
    guard let output: Decoder.Output = decoder.read(at: payloadIndexToRead, resolvePointers: resolvePointers) else {
      return nil
    }
    payloadIndexToRead = output.payloadRange.upperBound
    result.append(output.payload)
  }

  return Payload.dataCacheContainer(result)
}
