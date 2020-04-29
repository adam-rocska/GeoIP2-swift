import Foundation

extension Data {
  func index(of data: Data) -> Index? {
    let patternLength = data.count
    precondition(patternLength > 0)
    precondition(self.count >= patternLength)

    var skipTable = [UInt8: Int]()
    for (i, byte) in data.enumerated() {
      skipTable[byte] = patternLength - i - 1
    }

    let lastByteIndexOfData = data.index(before: data.endIndex)
    let lastByteOfData      = data.last
    var i                   = self.index(self.startIndex, offsetBy: patternLength - 1)

    func reverseMatch() -> Index? {
      var dataIndex = lastByteIndexOfData
      var selfIndex = i
      while dataIndex > data.startIndex {
        selfIndex = self.index(before: selfIndex)
        dataIndex = self.index(before: dataIndex)
        if self[selfIndex] != data[dataIndex] { return nil }
      }
      return selfIndex
    }

    while i < endIndex {
      let byte = self[i]

      if byte == lastByteOfData {
        if let foundIndex = reverseMatch() {
          return foundIndex
        }
        i = self.index(after: i)
      } else {
        i = self.index(
          i,
          offsetBy: skipTable[byte] ?? patternLength,
          limitedBy: self.endIndex
        ) ?? self.endIndex
      }
    }
    return nil
  }
}
