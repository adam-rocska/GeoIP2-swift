import Foundation

class PayloadInterpreter {

  typealias Input = (
    bytes: Data,
    controlByte: ControlByte,
    sourceEndianness: Endianness,
    controlStart: Data.Index,
    payloadStart: Data.Index
  )

  func interpret(input: Input, using decoder: Decoder, resolvePointers: Bool) -> Payload? {
    switch input.controlByte {
      case .pointer(let payloadSize, let strayBits):
        return interpretPointer(
          bytes: input.bytes,
          payloadSize: payloadSize,
          strayBits: strayBits,
          sourceEndianness: input.sourceEndianness,
          resolvePointers: resolvePointers,
          decoder: decoder
        )
      case .utf8String: return interpretUtf8String(bytes: input.bytes)
      case .double:     return interpretDouble(bytes: input.bytes, sourceEndianness: input.sourceEndianness)
      case .bytes:      return Payload.bytes(input.bytes)
      case .uInt16:     return interpretUInt16(bytes: input.bytes, sourceEndianness: input.sourceEndianness)
      case .uInt32:     return interpretUInt32(bytes: input.bytes, sourceEndianness: input.sourceEndianness)
      case .map(let entryCount):
        // TODO
        return Payload.map([:])
      case .int32:      return interpretInt32(bytes: input.bytes, sourceEndianness: input.sourceEndianness)
      case .uInt64:     return interpretUInt64(bytes: input.bytes, sourceEndianness: input.sourceEndianness)
      case .uInt128:    return Payload.uInt128(input.bytes)
      case .array(let entryCount): return interpretArray(
        entryCount: entryCount,
        decoder: decoder,
        payloadStart: input.payloadStart,
        resolvePointers: resolvePointers
      )
      case .dataCacheContainer(let entryCount): return interpretDataCacheContainer(
        entryCount: entryCount,
        decoder: decoder,
        payloadStart: input.payloadStart,
        resolvePointers: resolvePointers
      )
        return Payload.dataCacheContainer([])
      case .endMarker:            return Payload.endMarker
      case .boolean(let payload): return Payload.boolean(payload)
      case .float:                return interpretFloat(bytes: input.bytes, sourceEndianness: input.sourceEndianness)
    }
  }

}
