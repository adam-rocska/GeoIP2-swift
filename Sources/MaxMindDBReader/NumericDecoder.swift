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

  private func padded<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let byteCount           = MemoryLayout<T>.size - data.count
    let padBytes            = Data(count: byteCount)
    var wellSizedData: Data = input == .big ? padBytes + data : data + padBytes
    return UnsafeRawPointer(&wellSizedData).load(as: T.self)
  }

  private func truncated<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let byteCount = MemoryLayout<T>.size

    let bounds = input == .big
                 ? (
                   lower: data.limitedIndex(data.endIndex, offsetBy: -byteCount),
                   upper: data.endIndex
                 )
                 : (
                   lower: data.startIndex,
                   upper: data.limitedIndex(data.startIndex, offsetBy: byteCount)
                 )

    var wellSizedData: Data = data.subdata(in: Range(uncheckedBounds: bounds))
    return UnsafeRawPointer(&wellSizedData).load(as: T.self)
  }

  private func unpack<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let strayBytes = MemoryLayout<T>.size - data.count
    switch strayBytes {
      case _ where strayBytes > 0:
        return padded(data)
      case _ where strayBytes < 0:
        return truncated(data)
      default:
        var wellSizedData: Data = data
        return UnsafeRawPointer(&wellSizedData).load(as: T.self)
    }
  }

  func decode<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let unpacked: T = unpack(data)
    return input == .big
           ? unpacked.bigEndian
           : unpacked.littleEndian
  }

}

