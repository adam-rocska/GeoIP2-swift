import Foundation

public class MaxMindIterator {
  private let data:    Data
  private var pointer: Data.Index
  var isExhausted: Bool { get { return data.endIndex == pointer } }

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
      if let controlByte = peek(index: pointer) {
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

  private func peek(index: Data.Index) -> ControlByte? {
    let upperBound = data.index(
      index,
      offsetBy: 5,
      limitedBy: data.index(before: data.endIndex)
    ) ?? data.index(before: data.endIndex)
    if index == upperBound { return nil }
    let range = Range(uncheckedBounds: (lower: index, upper: upperBound))
    return ControlByte(bytes: data.subdata(in: range))
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
