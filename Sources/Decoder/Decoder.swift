import Foundation

public class Decoder {

  typealias Output = (
    payload: Payload,
    controlRange: Range<Data.Index>,
    payloadRange: Range<Data.Index>
  )

  private let data:                   Data
  private let controlByteInterpreter: ControlByteInterpreter
  private let payloadInterpreter:     PayloadInterpreter

  init(
    data: Data,
    controlByteInterpreter: ControlByteInterpreter,
    payloadInterpreter: PayloadInterpreter
  ) {
    precondition(!data.isEmpty, "Can't decode an empty binary.")
    self.data = data
    self.controlByteInterpreter = controlByteInterpreter
    self.payloadInterpreter = payloadInterpreter
  }

  private func rangeOfData(offset: Int, count: Int) -> Range<Data.Index> {
    let sliceStart = data.index(
      data.startIndex,
      offsetBy: offset,
      limitedBy: data.index(before: data.endIndex)
    ) ?? data.index(before: data.endIndex)

    let sliceEnd = data.index(
      sliceStart,
      offsetBy: count,
      limitedBy: data.endIndex
    ) ?? data.endIndex

    return Range(uncheckedBounds: (lower: sliceStart, upper: sliceEnd))
  }

  func read(at controlByteOffset: Int, resolvePointers: Bool = true) -> Output? {
    if controlByteOffset >= data.count { return nil }
    let controlByteCandidate = data.subdata(in: rangeOfData(offset: controlByteOffset, count: 5))
    guard let controlByteResult = controlByteInterpreter.interpret(
      bytes: controlByteCandidate,
      sourceEndianness: .big
    ) else {
      return nil
    }

    let payloadStart = controlByteOffset + controlByteResult.definition.count
    let payloadBytes: Data
    if let controlByteCount = controlByteResult.controlByte.byteCount {
      let payloadEnd = payloadStart + Int(controlByteCount)
      if payloadEnd > data.endIndex { return nil }
//      if !data.indices.contains(payloadEnd) { return nil }
      payloadBytes = data.subdata(in: rangeOfData(offset: payloadStart, count: Int(controlByteCount)))
    } else {
      payloadBytes = Data()
    }

    guard let payloadResult = payloadInterpreter.interpret(
      input: (
        bytes: payloadBytes,
        controlByte: controlByteResult.controlByte,
        sourceEndianness: .big,
        controlStart: controlByteOffset,
        payloadStart: payloadStart
      ),
      using: self,
      resolvePointers: resolvePointers
    ) else {
      return nil
    }

    let controlRange = Range(
      uncheckedBounds: (
        lower: controlByteOffset,
        upper: controlByteOffset + controlByteResult.definition.count
      )
    )
    let payloadRange = Range(
      uncheckedBounds: (
        lower: controlRange.upperBound,
        upper: controlRange.upperBound + Int(payloadResult.definitionSize)
      )
    )
    return (payloadResult.payload, controlRange, payloadRange)
  }

  public func read(at controlByteOffset: Int, resolvePointers: Bool = true) -> Payload? {
    guard let output: Output = read(at: controlByteOffset, resolvePointers: resolvePointers) else {
      return nil
    }
    return output.payload
  }

}
