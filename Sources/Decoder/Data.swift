import Foundation

internal extension Data {

  init(_ string: String) { self.init(string.utf8) }

  init<N>(_ numeric: N, targetEndianness: Endianness) where N: Numeric {
    var n = numeric
    if Endianness.current == targetEndianness {
      self.init(bytes: &n, count: MemoryLayout<N>.size)
    } else {
      self.init(Data(bytes: &n, count: MemoryLayout<N>.size).reversed())
    }
  }

}
