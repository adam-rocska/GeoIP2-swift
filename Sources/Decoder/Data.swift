import Foundation

enum Data {
  case pointer(UInt32)
  case utf8String(String)
  case double(Double)
  case bytes(Foundation.Data)
  case uInt16(UInt16)
  case uInt32(UInt32)
  indirect case map([String: Data])
  case int32(Int32)
  case uInt64(UInt64)
  case uInt128(Foundation.Data)
  indirect case array([Data])
  indirect case dataCacheContainer([Data])
  case endMarker
  case boolean(Bool)
  case float(Float)
}
