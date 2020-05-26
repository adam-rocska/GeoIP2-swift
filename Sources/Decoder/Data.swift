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

  func padded<N>(for Type: N.Type, as endian: Endianness) -> Data where N: FixedWidthInteger {
    let expectedSize = MemoryLayout<N>.size
    let count        = self.count
    // TODO : Figure out a good precondition message.
    precondition(count <= expectedSize)
    if count == expectedSize { return self }
    let concat: (Data, Data) -> Data = endian == .big ? { $0 + $1 } : { $1 + $0 }
    let mostSignificantByte = (endian == .big ? first : last) ?? 0x00

    let padByte = Type.isSigned && (mostSignificantByte & 0b1000_0000) == 0b1000_0000
                  ? UInt8(0xFF)
                  : UInt8(0x00)
    return concat(Data(repeating: padByte, count: expectedSize - count), self)
  }

}
