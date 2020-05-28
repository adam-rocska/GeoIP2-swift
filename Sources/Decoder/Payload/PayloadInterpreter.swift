import Foundation

class PayloadInterpreter {

  typealias Input = (
    bytes: Data,
    controlByte: ControlByte,
    sourceEndianness: Endianness,
    controlStart: Data.Index,
    payloadStart: Data.Index
  )

  // These function signatures are a hallmark of how the retarded php scripter designed database flaws are piled all together.
  private let interpretArray:              (UInt32, Decoder, Data.Index, Bool) -> InterpretationResult?
  private let interpretDataCacheContainer: (UInt32, Decoder, Data.Index, Bool) -> InterpretationResult?
  private let interpretDouble:             (Data, Endianness) -> Payload?
  private let interpretFloat:              (Data, Endianness) -> Payload?
  private let interpretInt32:              (Data, Endianness) -> Payload?
  private let interpretMap:                (UInt32, Decoder, Data.Index, Bool) -> InterpretationResult?
  private let interpretPointer:            (Data, UInt32, UInt8, Endianness, Bool, Decoder) -> Payload?
  private let interpretUInt16:             (Data, Endianness) -> Payload?
  private let interpretUInt32:             (Data, Endianness) -> Payload?
  private let interpretUInt64:             (Data, Endianness) -> Payload?
  private let interpretUtf8String:         (Data) -> Payload?

  typealias InterpretationResult = (payload: Payload, definitionSize: UInt32)

  init(
    interpretArray: @escaping (UInt32, Decoder, Data.Index, Bool) -> InterpretationResult?,
    interpretDataCacheContainer: @escaping (UInt32, Decoder, Data.Index, Bool) -> InterpretationResult?,
    interpretDouble: @escaping (Data, Endianness) -> Payload?,
    interpretFloat: @escaping (Data, Endianness) -> Payload?,
    interpretInt32: @escaping (Data, Endianness) -> Payload?,
    interpretMap: @escaping (UInt32, Decoder, Data.Index, Bool) -> InterpretationResult?,
    interpretPointer: @escaping (Data, UInt32, UInt8, Endianness, Bool, Decoder) -> Payload?,
    interpretUInt16: @escaping (Data, Endianness) -> Payload?,
    interpretUInt32: @escaping (Data, Endianness) -> Payload?,
    interpretUInt64: @escaping (Data, Endianness) -> Payload?,
    interpretUtf8String: @escaping (Data) -> Payload?
  ) {
    self.interpretArray = interpretArray
    self.interpretDataCacheContainer = interpretDataCacheContainer
    self.interpretDouble = interpretDouble
    self.interpretFloat = interpretFloat
    self.interpretInt32 = interpretInt32
    self.interpretMap = interpretMap
    self.interpretPointer = interpretPointer
    self.interpretUInt16 = interpretUInt16
    self.interpretUInt32 = interpretUInt32
    self.interpretUInt64 = interpretUInt64
    self.interpretUtf8String = interpretUtf8String
  }

  func interpret(input: Input, using decoder: Decoder, resolvePointers: Bool) -> InterpretationResult? {
    switch input.controlByte {
      case .pointer(let payloadSize, let strayBits):
        guard let payload = interpretPointer(
          input.bytes,
          payloadSize,
          strayBits,
          input.sourceEndianness,
          resolvePointers,
          decoder
        ) else { return nil }
        return (payload, payloadSize)
      case .utf8String(let payloadSize):
        guard let payload = interpretUtf8String(input.bytes) else { return nil }
        return (payload, payloadSize)
      case .double(let payloadSize):
        guard let payload = interpretDouble(input.bytes, input.sourceEndianness) else { return nil }
        return (payload, payloadSize)
      case .bytes(let payloadSize):
        return (Payload.bytes(input.bytes), payloadSize)
      case .uInt16(let payloadSize):
        guard let payload = interpretUInt16(input.bytes, input.sourceEndianness) else { return nil }
        return (payload, payloadSize)
      case .uInt32(let payloadSize):
        guard let payload = interpretUInt32(input.bytes, input.sourceEndianness) else { return nil }
        return (payload, payloadSize)
      case .map(let entryCount):
        return interpretMap(entryCount, decoder, input.payloadStart, resolvePointers)
      case .int32(let payloadSize):
        guard let payload = interpretInt32(input.bytes, input.sourceEndianness) else { return nil }
        return (payload, payloadSize)
      case .uInt64(let payloadSize):
        guard let payload = interpretUInt64(input.bytes, input.sourceEndianness) else { return nil }
        return (payload, payloadSize)
      case .uInt128(let payloadSize):
        return (Payload.uInt128(input.bytes), payloadSize)
      case .array(let entryCount):
        return interpretArray(entryCount, decoder, input.payloadStart, resolvePointers)
      case .dataCacheContainer(let entryCount):
        return interpretDataCacheContainer(entryCount, decoder, input.payloadStart, resolvePointers)
      case .endMarker:
        return (Payload.endMarker, 0)
      case .boolean(let value):
        return (Payload.boolean(value), 0)
      case .float(let payloadSize):
        guard let payload = interpretFloat(input.bytes, input.sourceEndianness) else { return nil }
        return (payload, payloadSize)
    }
  }

}
