import Foundation

public extension MaxMindDecoder {
  func decode(_ data: Data) -> String {
    return String(data: data, encoding: .utf8) ?? ""
  }
}
