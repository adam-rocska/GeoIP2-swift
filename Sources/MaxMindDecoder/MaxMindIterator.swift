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

  private func peek(index: Data.Index, controlByte: ControlByte) -> (data: Data?, upperBound: Data.Index) {
    let upperBound = data.index(
      pointer,
      offsetBy: Int(controlByte.payloadSize),
      limitedBy: data.endIndex
    ) ?? data.endIndex
    if controlByte.payloadSize == 0 { return (data: Data(), upperBound: upperBound) }
    return (
      data: data.subdata(in: Range(uncheckedBounds: (lower: pointer, upper: upperBound))),
      upperBound: upperBound
    )
  }

  public func next(_ controlByte: ControlByte) -> Data? {
    let (payload, upperBound) = peek(index: pointer, controlByte: controlByte)
    pointer = upperBound
    return payload
  }

}
