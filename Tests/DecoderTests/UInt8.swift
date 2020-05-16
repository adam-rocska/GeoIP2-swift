import Foundation

extension UInt8 {
  var description: String {
    let binaryBase = String(self, radix: 2)
    return String(repeating: "0", count: 8 - binaryBase.count) + binaryBase
  }
}
