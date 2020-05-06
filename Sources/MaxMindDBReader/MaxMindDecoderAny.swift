import Foundation

extension MaxMindDecoder {

  // TODO : Create tests for this piece of 💩
  func decode(_ iterator: MaxMindIterator, as controlByte: ControlByte) -> Any {
    switch controlByte.type {
      case .map:
        return decode(iterator, size: Int(controlByte.payloadSize)) as [String:Any]
      case .array:
        return decode(iterator, size: Int(controlByte.payloadSize)) as [Any]
      default:
        preconditionFailure("Iterator based control byte decoding can only be done on sequential types.")
    }
  }

  // TODO : Finish the implementation & test of this piece of 💩
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
        return decode(data, size: Int(controlByte.payloadSize)) as [String: Any]
      case .int32:
        return decode(data) as Int32
      case .uInt64:
        return decode(data) as UInt64
      case .uInt128:
        // TODO
        return 0
      case .array:
        return decode(data, size: Int(controlByte.payloadSize)) as [Any]
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
