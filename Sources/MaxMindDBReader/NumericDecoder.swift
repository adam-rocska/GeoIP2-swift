import Foundation

/**
# NumericDecoder
Unit capable of decoding MaxMind DB's specific unorthodox way of storing data.
It's able to unpack the php style random byte sized "strongly typed" values.
 */
class NumericDecoder {

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

  private func unpack<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let strayBytes = MemoryLayout<T>.size - data.count
    var wellSizedData: Data
    /// TODO : Move the unsafe raw pointer based type creation into truncate & pad. That way we can handle the php monkeys' integer signing problem
    switch strayBytes {
      case _ where strayBytes > 0:
        wellSizedData = pad(data, byteCount: strayBytes)
      case _ where strayBytes < 0:
        wellSizedData = truncate(data, byteCount: MemoryLayout<T>.size)
      default:
        wellSizedData = data
    }
    return UnsafeRawPointer(&wellSizedData).load(as: T.self)
  }

  func decode<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let unpacked: T = unpack(data)
    return input == .big
           ? unpacked.bigEndian
           : unpacked.littleEndian
  }

}

