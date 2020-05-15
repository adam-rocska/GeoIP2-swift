import Foundation

public extension MaxMindDecoder {

  private func resolveKey(_ iterator: MaxMindIterator) -> String? {
    switch iterator.next() {
      case .some(let cb) where cb.type == .pointer:
        return nil
      case .some(let cb) where cb.type == .utf8String:
        return decode(iterator.next(cb))
      default:
        return nil
    }
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
