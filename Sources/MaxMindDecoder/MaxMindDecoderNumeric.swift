import Foundation

public extension MaxMindDecoder {

  private func getLeadingByte(_ data: Data) -> Data.Element? {
    return input == .big ? data.first : data.last
  }

  private func isNegative(_ data: Data) -> Bool {
    guard let leadingByte = getLeadingByte(data) else { return false }
    return (leadingByte & 0b1000_0000) == 0b1000_0000
  }

  private func padded<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let padBytes            = Data(
      repeating: T.isSigned && isNegative(data) ? 0b1111_1111 : 0b0000_0000,
      count: MemoryLayout<T>.size - data.count
    )
    var wellSizedData: Data = input == .big ? padBytes + data : data + padBytes
    return UnsafeRawPointer(&wellSizedData).load(as: T.self)
  }

  private func truncated<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let bounds: (lower: Range<Data.Index>.Bound, upper: Range<Data.Index>.Bound)
    if input == .big {
      bounds = (
        lower: data.index(
          data.endIndex,
          offsetBy: -MemoryLayout<T>.size,
          limitedBy: data.startIndex
        ) ?? data.startIndex,
        upper: data.endIndex
      )
    } else {
      bounds = (
        lower: data.startIndex,
        upper: data.index(
          data.startIndex,
          offsetBy: MemoryLayout<T>.size,
          limitedBy: data.endIndex
        ) ?? data.endIndex
      )
    }
    var wellSizedData: Data = data.subdata(in: Range(uncheckedBounds: bounds))
    return UnsafeRawPointer(&wellSizedData).load(as: T.self)
  }

  private func unpack<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let strayBytes = MemoryLayout<T>.size - data.count
    if strayBytes > 0 { return padded(data) }
    if strayBytes < 0 { return truncated(data) }
    var wellSizedData: Data = data
    return UnsafeRawPointer(&wellSizedData).load(as: T.self)
  }

  func decode<T>(_ data: Data) -> T where T: FixedWidthInteger {
    let unpacked: T = unpack(data)
    return input == .big
           ? unpacked.bigEndian
           : unpacked.littleEndian
  }

}
