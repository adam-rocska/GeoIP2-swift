import Foundation

public class MaxMindIterator {

  public typealias Pointer = Data.Index

  private let data:    Data
  private var pointer: Pointer
  var isExhausted: Bool { get { return data.endIndex == pointer } }

  public struct Entry {
    public let controlByte: ControlByte
    public let position:    Pointer

    private init(controlByte: ControlByte, position: Pointer) {
      precondition(controlByte.type != .pointer, "MaxMind pointer values mustn't be exposed.")
      self.controlByte = controlByte
      self.position = position
    }
  }

  public func rewind() { pointer = data.startIndex }

  public func seek(to: Int) {
    pointer = data.index(
      data.startIndex,
      offsetBy: to,
      limitedBy: data.index(before: data.endIndex)
    ) ?? data.index(before: data.endIndex)
  }

  public init?(_ data: Data) {
    if data.isEmpty { return nil }
    self.data = data
    self.pointer = data.startIndex
  }

  public func next() -> ControlByte? {
    while !isExhausted {
      let range = Range(uncheckedBounds: (
        lower: pointer,
        upper: data.index(
          pointer,
          offsetBy: 5,
          limitedBy: data.index(before: data.endIndex)
        ) ?? data.index(before: data.endIndex)
      ))
      if range.lowerBound == range.upperBound { break }

      if let controlByte = ControlByte(bytes: data.subdata(in: range)) {
        pointer = data.index(
          pointer,
          offsetBy: Int(controlByte.definitionSize),
          limitedBy: data.index(before: data.endIndex)
        ) ?? data.index(before: data.endIndex)
        return controlByte
      }
      pointer = data.index(after: pointer)
    }
    return nil
  }

  public func next(_ controlByte: ControlByte) -> Data? {
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
