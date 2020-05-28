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

public extension Payload {
  func unwrap<T>() -> T? {
    switch self {
      case .pointer(let value)            where value is T: return (value as! T)
      case .utf8String(let value)         where value is T: return (value as! T)
      case .double(let value)             where value is T: return (value as! T)
      case .bytes(let value)              where value is T: return (value as! T)
      case .uInt16(let value)             where value is T: return (value as! T)
      case .uInt32(let value)             where value is T: return (value as! T)
      case .map(let value)                where value is T: return (value as! T)
      case .int32(let value)              where value is T: return (value as! T)
      case .uInt64(let value)             where value is T: return (value as! T)
      case .uInt128(let value)            where value is T: return (value as! T)
      case .array(let value)              where value is T: return (value as! T)
      case .dataCacheContainer(let value) where value is T: return (value as! T)
      case .boolean(let value)            where value is T: return (value as! T)
      case .float(let value)              where value is T: return (value as! T)
      default: return nil
    }
  }

}