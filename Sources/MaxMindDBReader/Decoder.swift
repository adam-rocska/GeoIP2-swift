import Foundation

class Decoder {

  enum Endianness { case big, little }

  private let input: Endianness

  init(inputEndianness: Endianness) { self.input = inputEndianness }

  private func pad(_ data: Data, byteCount: Int) -> Data {
    let padBytes = Data(count: byteCount)
    return input == .big ? padBytes + data : data + padBytes
  }

  private func truncate(_ data: Data, byteCount: Int) -> Data {
    let bounds = input == .big
                 ? (
                   lower: data.limitedIndex(data.endIndex, offsetBy: -byteCount),
                   upper: data.endIndex
                 )
                 : (
                   lower: data.startIndex,
                   upper: data.limitedIndex(data.startIndex, offsetBy: byteCount)
                 )
    return data.subdata(in: Range(uncheckedBounds: bounds))
  }

  private func unpack(_ data: Data, toBytesLength to: Int) -> Data {
    let strayBytes = to - data.count
    switch strayBytes {
      case _ where strayBytes > 0:
        return pad(data, byteCount: strayBytes)
      case _ where strayBytes < 0:
        return truncate(data, byteCount: to)
      default:
        return data
    }
  }

  func decode(_ data: Data) -> UInt16 {
    var wellSizedData = unpack(data, toBytesLength: 2)
    let value         = UnsafeRawPointer(&wellSizedData).load(as: UInt16.self)
    return input == .big ? value.bigEndian : value.littleEndian
  }
}
