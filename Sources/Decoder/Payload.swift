import Foundation

public enum Payload: Equatable {
  case pointer(UInt32)
  case utf8String(String)
  case double(Double)
  case bytes(Data)
  case uInt16(UInt16)
  case uInt32(UInt32)
  case map([String: Payload])
  case int32(Int32)
  case uInt64(UInt64)
  case uInt128(Data)
  case array([Payload])
  case dataCacheContainer([Payload])
  case endMarker
  case boolean(Bool)
  case float(Float)
}
