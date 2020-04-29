import Foundation
#if os(Linux)
  import Glibc
#else
  import Darwin
#endif

class Decoder {

  private let pointerBaseByteSize: UInt
  private var pointerBase:         UInt
  private lazy var switchByteOrder: Bool = { 0.littleEndian == 0 }()

  init(pointerBase: UInt = 0) {
    precondition(log(Float(pointerBase)).truncatingRemainder(dividingBy: 8.0) == 0)

    self.pointerBaseByteSize = UInt(log(Float(pointerBase)) / 8.0)
    self.pointerBase = pointerBase
  }

}
