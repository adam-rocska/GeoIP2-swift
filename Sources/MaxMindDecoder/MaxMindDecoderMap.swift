import Foundation

public extension MaxMindDecoder {

  func decode(_ iterator: MaxMindIterator, size: Int) -> [String: Any] {
    var result: [String: Any] = [:]
    for _ in 0..<size {
      guard let keyControlByte = iterator.next() else { break }
      if keyControlByte.type != .utf8String { break }
      let keyBinary = iterator.next(keyControlByte)
      let key: String = decode(keyBinary)

      guard let valueControlByte = iterator.next() else { break }
      switch valueControlByte.type {
        case .map, .array:
          result[key] = decode(iterator, as: valueControlByte)
        default:
          let valueBinary = iterator.next(valueControlByte)
          result[key] = decode(valueBinary, as: valueControlByte)
      }
    }
    return result
  }

  func decode(_ data: Data, size: Int) -> [String: Any] {
    guard let iterator = MaxMindIterator(data) else { return [:] }
    return decode(iterator, size: size)
  }
}
