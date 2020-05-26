import Foundation

class ControlByteInterpreter {

  typealias InterpretationResult = (controlByte: ControlByte, definition: Data)

  private let resolveType:           (Data, Endianness) -> DataType?
  private let resolvePayloadSize:    (DataType, Data, Endianness) -> UInt32?
  private let resolveDefinitionSize: (DataType, Data, Endianness) -> UInt8?

  init(
    typeResolver resolveType: @escaping (Data, Endianness) -> DataType?,
    payloadSizeResolver resolvePayloadSize: @escaping (DataType, Data, Endianness) -> UInt32?,
    definitionSizeResolver resolveDefinitionSize: @escaping (DataType, Data, Endianness) -> UInt8?
  ) {
    self.resolveType = resolveType
    self.resolvePayloadSize = resolvePayloadSize
    self.resolveDefinitionSize = resolveDefinitionSize
  }

  func interpret(bytes: Data, sourceEndianness: Endianness) -> InterpretationResult? {
    if !(1...5 ~= bytes.count) { return nil }
    guard let dataType = resolveType(bytes, sourceEndianness) else { return nil }
    guard let payloadSize = resolvePayloadSize(dataType, bytes, sourceEndianness) else { return nil }
    guard let definitionSize = resolveDefinitionSize(dataType, bytes, sourceEndianness) else { return nil }

    let controlByte: ControlByte
    switch dataType {
      case .pointer:            controlByte = ControlByte.pointer(
        payloadSize: payloadSize,
        strayBits: (sourceEndianness == .big ? bytes.first! : bytes.last!) & 0b0000_0111
      )
      case .utf8String:         controlByte = ControlByte.utf8String(payloadSize: payloadSize)
      case .double:             controlByte = ControlByte.double(payloadSize: payloadSize)
      case .bytes:              controlByte = ControlByte.bytes(payloadSize: payloadSize)
      case .uInt16:             controlByte = ControlByte.uInt16(payloadSize: payloadSize)
      case .uInt32:             controlByte = ControlByte.uInt32(payloadSize: payloadSize)
      case .map:                controlByte = ControlByte.map(entryCount: payloadSize)
      case .int32:              controlByte = ControlByte.int32(payloadSize: payloadSize)
      case .uInt64:             controlByte = ControlByte.uInt64(payloadSize: payloadSize)
      case .uInt128:            controlByte = ControlByte.uInt128(payloadSize: payloadSize)
      case .array:              controlByte = ControlByte.array(entryCount: payloadSize)
      case .dataCacheContainer: controlByte = ControlByte.dataCacheContainer(entryCount: payloadSize)
      case .endMarker:          controlByte = ControlByte.endMarker
      case .boolean:            controlByte = ControlByte.boolean(payload: payloadSize != 0)
      case .float:              controlByte = ControlByte.float(payloadSize: payloadSize)
    }

    if sourceEndianness == .big {
      return (controlByte, bytes[..<definitionSize])
    }
    return (
      controlByte,
      bytes.subdata(
        in: Range(
          uncheckedBounds: (
            lower: bytes.index(bytes.endIndex, offsetBy: -Int(definitionSize)),
            upper: bytes.endIndex
          )
        )
      )
    )
  }

}
