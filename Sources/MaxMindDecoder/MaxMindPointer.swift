import Foundation

public struct MaxMindPointer {
  fileprivate var value: UInt

  public init(_ value: UInt) { self.value = value }
}

public extension UInt {
  init(_ maxMindPointer: MaxMindPointer) {
    self.init(maxMindPointer.value)
  }
}