import Foundation

enum ControlByte {

  case pointer(payloadSize: UInt32, strayBits: UInt8)
  case utf8String(payloadSize: UInt32)
  case double(payloadSize: UInt32)
  case bytes(payloadSize: UInt32)
  case uInt16(payloadSize: UInt32)
  case uInt32(payloadSize: UInt32)
  case map(payloadSize: UInt32)
  case int32(payloadSize: UInt32)
  case uInt64(payloadSize: UInt32)
  case uInt128(payloadSize: UInt32)
  case array(payloadSize: UInt32)
  case dataCacheContainer(payloadSize: UInt32)
  case endMarker(payloadSize: UInt32)
  case boolean(payloadSize: UInt32)
  case float(payloadSize: UInt32)

}

extension ControlByte {
  var type: DataType {
    switch self {
      case .pointer: return DataType.pointer
      case .utf8String: return DataType.utf8String
      case .double: return DataType.double
      case .bytes: return DataType.bytes
      case .uInt16: return DataType.uInt16
      case .uInt32: return DataType.uInt32
      case .map: return DataType.map
      case .int32: return DataType.int32
      case .uInt64: return DataType.uInt64
      case .uInt128: return DataType.uInt128
      case .array: return DataType.array
      case .dataCacheContainer: return DataType.dataCacheContainer
      case .endMarker: return DataType.endMarker
      case .boolean: return DataType.boolean
      case .float: return DataType.float
    }
  }
}