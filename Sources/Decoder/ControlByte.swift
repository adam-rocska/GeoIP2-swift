import Foundation

enum ControlByte: Equatable {
  case pointer(payloadSize: UInt32, strayBits: UInt8)
  case utf8String(payloadSize: UInt32)
  case double(payloadSize: UInt32)
  case bytes(payloadSize: UInt32)
  case uInt16(payloadSize: UInt32)
  case uInt32(payloadSize: UInt32)
  case map(entryCount: UInt32)
  case int32(payloadSize: UInt32)
  case uInt64(payloadSize: UInt32)
  case uInt128(payloadSize: UInt32)
  case array(entryCount: UInt32)
  case dataCacheContainer(entryCount: UInt32)
  case endMarker
  case boolean(payload: Bool)
  case float(payloadSize: UInt32)

  var byteCount: UInt32? {
    get {
      switch self {
        case .pointer(let payloadSize, _): return payloadSize
        case .utf8String(let payloadSize): return payloadSize
        case .double(let payloadSize):     return payloadSize
        case .bytes(let payloadSize):      return payloadSize
        case .uInt16(let payloadSize):     return payloadSize
        case .uInt32(let payloadSize):     return payloadSize
        case .map:                         return nil
        case .int32(let payloadSize):      return payloadSize
        case .uInt64(let payloadSize):     return payloadSize
        case .uInt128(let payloadSize):    return payloadSize
        case .array:                       return nil
        case .dataCacheContainer:          return nil
        case .endMarker:                   return nil
        case .boolean:                     return nil
        case .float(let payloadSize):      return payloadSize
      }
    }
  }
}
