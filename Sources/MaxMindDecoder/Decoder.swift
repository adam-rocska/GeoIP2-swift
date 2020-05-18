import Foundation

class Decoder {

  public enum Endianness { case big, little }

  let input: Endianness

  public init(inputEndianness: Endianness) { self.input = inputEndianness }

  func decode(_ input: InputData) -> OutputData {
    switch input {
      case .pointer(let bytes, let strayBits):
        return decodeAsPointer(bytes, strayBits: strayBits)
      case .utf8String(let bytes):
        return decodeAsString(bytes)
      case .double(let bytes):
        return decodeAsDouble(bytes: bytes)
    }
  }

}
