import Foundation

class PayloadInterpreter {

  typealias Input = (
    bytes: Data,
    controlByte: ControlByte,
    sourceEndianness: Endianness,
    controlStart: Data.Index,
    payloadStart: Data.Index
  )

  typealias InterpretationResult = (payload: Payload, definitionSize: UInt32)

  func interpret(input: Input, using decoder: Decoder, resolvePointers: Bool) -> InterpretationResult? {
    switch input.controlByte {
      case .pointer(let payloadSize, let strayBits):
        guard let payload = interpretPointer(
          bytes: input.bytes,
          payloadSize: payloadSize,
          strayBits: strayBits,
          sourceEndianness: input.sourceEndianness,
          resolvePointers: resolvePointers,
          decoder: decoder
        ) else { return nil }
        return (payload, payloadSize)
      case .utf8String(let payloadSize):
        guard let payload = interpretUtf8String(bytes: input.bytes) else { return nil }
        return (payload, payloadSize)
      case .double(let payloadSize):
        guard let payload = interpretDouble(
          bytes: input.bytes,
          sourceEndianness: input.sourceEndianness
        ) else { return nil }
        return (payload, payloadSize)
      case .bytes(let payloadSize):
        return (Payload.bytes(input.bytes), payloadSize)
      case .uInt16(let payloadSize):
        guard let payload = interpretUInt16(
          bytes: input.bytes,
          sourceEndianness: input.sourceEndianness
        ) else { return nil }
        return (payload, payloadSize)
      case .uInt32(let payloadSize):
        guard let payload = interpretUInt32(bytes: input.bytes, sourceEndianness: input.sourceEndianness) else {
          return nil
        }
        return (payload, payloadSize)
      case .map(let entryCount):
        return interpretMap(
          entryCount: entryCount,
          decoder: decoder,
          payloadStart: input.payloadStart,
          resolvePointers: resolvePointers
        )
      case .int32(let payloadSize):
        guard let payload = interpretInt32(
          bytes: input.bytes,
          sourceEndianness: input.sourceEndianness
        ) else { return nil }
        return (payload, payloadSize)
      case .uInt64(let payloadSize):
        guard let payload = interpretUInt64(
          bytes: input.bytes,
          sourceEndianness: input.sourceEndianness
        ) else { return nil }
        return (payload, payloadSize)
      case .uInt128(let payloadSize):
        return (Payload.uInt128(input.bytes), payloadSize)
      case .array(let entryCount):
        return interpretArray(
          entryCount: entryCount,
          decoder: decoder,
          payloadStart: input.payloadStart,
          resolvePointers: resolvePointers
        )
      case .dataCacheContainer(let entryCount):
        return interpretDataCacheContainer(
          entryCount: entryCount,
          decoder: decoder,
          payloadStart: input.payloadStart,
          resolvePointers: resolvePointers
        )
      case .endMarker:
        return (Payload.endMarker, 0)
      case .boolean(let value):
        return (Payload.boolean(value), 0)
      case .float(let payloadSize):
        guard let payload = interpretFloat(
          bytes: input.bytes,
          sourceEndianness: input.sourceEndianness
        ) else { return nil }
        return (payload, payloadSize)
    }
  }

}
