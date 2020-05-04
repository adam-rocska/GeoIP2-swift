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

  func nextControlByte() -> ControlByte? {
    return nil
  }

  func nextValue() -> Any? {
    return nil
  }

}
