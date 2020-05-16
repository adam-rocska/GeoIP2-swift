import Foundation

class MaxMindPointerResolver {

  typealias ResolvedValue = (controlByte: ControlByte, value: Any)

  private let dataSequence: PeekableDataSequence
  private let decoder:      MaxMindDecoder

  init(dataSequence: PeekableDataSequence, decoder: MaxMindDecoder) {
    self.dataSequence = dataSequence
    self.decoder = decoder
  }

  func resolve(_ pointer: MaxMindPointer) -> ResolvedValue? {
    let pointerPosition = Int(pointer)
    guard let controlByte = dataSequence.peek(at: pointerPosition) else { return nil }
    let controlByteOffset = Int(controlByte.definitionSize)
    guard let data = dataSequence.peek(controlByte, at: pointerPosition + controlByteOffset) else { return nil }
    return (
      controlByte: controlByte,
      value: decoder.decode(data, as: controlByte)
    )
  }

}
