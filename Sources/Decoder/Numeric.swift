import Foundation

public extension Numeric {

  init(_ data: Data, sourceEndianness: Endianness) {
    var value: Self = .zero
    let size:  Int
    if Endianness.current == sourceEndianness {
      size = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0) })
    } else {
      size = withUnsafeMutableBytes(of: &value, { Data(data.reversed()).copyBytes(to: $0) })
    }
    assert(size == MemoryLayout.size(ofValue: value))
    self = value
  }

}
