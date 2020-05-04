//
// Created by Rocska Ádám on 2020. 05. 04..
//

import Foundation

class MaxMindIterator {
  private let data:    Data
  private var pointer: Data.Index

  init?(_ data: Data) {
    if data.isEmpty { return nil }
    self.data = data
    self.pointer = data.startIndex
  }

  func next() -> ControlByte? {
    while pointer != data.limitedIndex(before: data.endIndex) {
      let range = Range(uncheckedBounds: (
        lower: pointer,
        upper: data.limitedIndex(pointer, offsetBy: 5)
      ))
      pointer = data.index(after: pointer)
      if range.lowerBound == range.upperBound {
        break
      }

      if let controlByte = ControlByte(bytes: data.subdata(in: range)) {
        return controlByte
      }
    }
    return nil
  }

  func next(_ controlByte: ControlByte) -> Data? {
    if controlByte.payloadSize == 0 { return Data() }
    let range = Range(uncheckedBounds: (
      lower: pointer,
      upper: data.limitedIndex(pointer, offsetBy: Int(controlByte.payloadSize))
    ))
    pointer = range.upperBound
    if range.lowerBound == range.upperBound { return Data() }
    return data.subdata(in: range)
  }

}
