import Foundation

extension Foundation.Data {
  var description: String {
    var description = ""
    var byteCount   = 0
    for byte in self {
      byteCount += 1
      description += byte.description
      description += byteCount % 4 == 0 ? "\n" : " "
    }
    return description
  }
}
