import Foundation

extension MaxMindDecoder {

  func decode(_ data: Data, as controlByte: ControlByte) -> Any {
    switch controlByte.type {
      case .pointer:
        // TODO
        return 0
      case .utf8String:
        return decode(data) as String
      case .double:
        // TODO
        return 0
      case .bytes:
        return data
      case .uInt16:
        return decode(data) as UInt16
      case .uInt32:
        return decode(data) as UInt32
      case .map:
        return 0
      case .int32:
        return decode(data) as Int32
      case .uInt64:
        return decode(data) as UInt64
      case .uInt128:
        // TODO
        return 0
      case .array:
        // TODO
        return 0
      case .dataCacheContainer:
        // TODO
        return 0
      case .endMarker:
        // TODO
        return 0
      case .boolean:
        return controlByte.payloadSize == 1
      case .float:
        // TODO
        return 0
    }
  }

}
