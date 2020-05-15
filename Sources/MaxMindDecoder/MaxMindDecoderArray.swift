import Foundation

public extension MaxMindDecoder {

  func decode(_ data: Data, size: Int) -> [Any] {
    guard let iterator = MaxMindIterator(data) else { return [] }
    return decode(iterator, size: size)
  }

  func decode(_ iterator: MaxMindIterator, size: Int) -> [Any] {
    var result: [Any] = []
    for _ in 0..<size {
      guard let controlByte = iterator.next() else { break }
      let binary = iterator.next(controlByte)
      result.append(decode(binary, as: controlByte))
    }
    return result
  }

}