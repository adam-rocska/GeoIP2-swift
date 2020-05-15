import Foundation

public extension MaxMindDecoder {

  private func resolveKey(_ iterator: MaxMindIterator) -> String? {
    guard let keyControlByte = iterator.next() else { return nil }
    if keyControlByte.type != .utf8String { return nil }
    let keyBinary = iterator.next(keyControlByte)
    return decode(keyBinary)
  }

  func decode(_ iterator: MaxMindIterator, size: Int) -> [String: Any] {
    var result: [String: Any] = [:]
    for _ in 0..<size {
      guard let key: String = resolveKey(iterator) else { break }

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
