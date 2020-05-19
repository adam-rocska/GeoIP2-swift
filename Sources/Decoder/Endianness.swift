import Foundation

public enum Endianness {
  case little, big

  static var current: Endianness {
    get {
      switch CFByteOrderGetCurrent() {
        case CFByteOrder(CFByteOrderLittleEndian.rawValue): return .little
        case CFByteOrder(CFByteOrderBigEndian.rawValue): return .big
        default: preconditionFailure("Could not determine Byte Order of the current platform.")
      }
    }
  }

}
