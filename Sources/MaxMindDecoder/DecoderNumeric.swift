import Foundation

extension Decoder {

  func decodeAsDouble(bytes: Data) -> OutputData {
    precondition(bytes.count == MemoryLayout<Double>.size, "Only 64bit data can be decoded as Double.")
    return OutputData.double(5)
  }

}