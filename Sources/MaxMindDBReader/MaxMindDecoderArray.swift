import Foundation

extension MaxMindDecoder {

  func decode(_ data: Data, size: Int) -> [Any] {
    guard let iterator = MaxMindIterator(data) else { return [] }
    var result: [Any] = []
    for _ in 0..<size {
      guard let controlByte = iterator.next() else { break }
      guard let binary = iterator.next(controlByte) else { break }
      result.append(decode(binary, as: controlByte))
    }
    return result
  }

}