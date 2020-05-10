import Foundation

public class MaxMindIterator {
  private let data:    Data
  private var pointer: Data.Index
  var isExhausted: Bool { get { return data.endIndex == pointer } }

  func rewind() { pointer = data.startIndex }

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
          limitedBy: data.endIndex
        ) ?? data.endIndex
      ))
      if range.lowerBound == range.upperBound { break }

      if let controlByte = ControlByte(bytes: data.subdata(in: range)) {
        pointer = data.index(
          pointer,
          offsetBy: Int(controlByte.definitionSize),
          limitedBy: data.endIndex
        ) ?? data.endIndex
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
