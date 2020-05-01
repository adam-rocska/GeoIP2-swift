import Foundation
#if os(Linux)
  import Glibc
#else
  import Darwin
#endif

class Decoder {

  private let data:                Data
  private var pointerBase:         UInt
  private let pointerBaseByteSize: UInt
  private lazy var switchByteOrder: Bool = { 0.littleEndian == 0 }()

  init(data: Data, pointerBase: UInt = 0) {
    precondition(log(Float(pointerBase)).truncatingRemainder(dividingBy: 8.0) == 0)
    self.data = data
    self.pointerBase = pointerBase
    self.pointerBaseByteSize = UInt(log(Float(pointerBase)) / 8.0)
  }

  func decode(from offset: Data.Index) {
    let controlByte    = data[offset]
    let typeIdentifier = controlByte >> 5
  }

}
