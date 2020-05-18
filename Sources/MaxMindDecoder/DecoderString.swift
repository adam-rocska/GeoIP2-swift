import Foundation

extension Decoder {

  func decodeAsString(_ data: Data) -> OutputData {
    return OutputData.utf8String(String(data: data, encoding: .utf8) ?? "")
  }

}
