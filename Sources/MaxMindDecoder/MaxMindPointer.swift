import Foundation

public struct MaxMindPointer: Equatable {
  fileprivate var value: UInt32

  public init(_ value: UInt32) { self.value = value }
}

public extension UInt32 {
  init(_ maxMindPointer: MaxMindPointer) {
    self.init(maxMindPointer.value)
  }
}

public extension Int {
  init(_ maxMindPointer: MaxMindPointer) {
    self.init(maxMindPointer.value)
  }
}