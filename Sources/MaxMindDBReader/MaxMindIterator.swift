//
// Created by Rocska Ádám on 2020. 05. 04..
//

import Foundation

class MaxMindIterator {
  private let data:    Data
  private var pointer: Data.Index
  var isExhausted: Bool { get { return data.endIndex == pointer } }

  init?(_ data: Data) {
    if data.isEmpty { return nil }
    self.data = data
    self.pointer = data.startIndex
  }

  func next() -> ControlByte? {
    while !isExhausted {
      let range = Range(uncheckedBounds: (
        lower: pointer,
        upper: data.limitedIndex(pointer, offsetBy: 5)
      ))
      if range.lowerBound == range.upperBound { break }

      if let controlByte = ControlByte(bytes: data.subdata(in: range)) {
        pointer = data.limitedIndex(pointer, offsetBy: Int(controlByte.definitionSize))
        return controlByte
      }
      pointer = data.index(after: pointer)
    }
    return nil
  }

  func rewind() { pointer = data.startIndex }

  func next(_ controlByte: ControlByte) -> Data? {
    let range = Range(uncheckedBounds: (
      lower: pointer,
      upper: data.index(pointer, offsetBy: Int(controlByte.payloadSize))
    ))
    pointer = range.upperBound
    if controlByte.payloadSize == 0 { return Data() }
    if range.lowerBound == range.upperBound { return Data() }
    return data.subdata(in: range)
  }

}
