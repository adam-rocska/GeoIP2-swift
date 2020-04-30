import Foundation

extension UInt8 {

  @inlinable func areBitsSet(bitMask: UInt8) -> Bool {
    return (self & bitMask) > 0
  }

}
