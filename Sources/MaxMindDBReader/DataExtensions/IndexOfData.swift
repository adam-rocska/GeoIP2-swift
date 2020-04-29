import Foundation

extension Data {
  func index(of data: Data) -> Index? {
    let patternLength = data.count
    let selfLength    = self.count
    precondition(patternLength > 0)
    precondition(selfLength >= patternLength)

    var skipTable = [UInt8: Index]()
    for index in data.indices {
      skipTable[data[index]] = index
    }

//    let lastByteIndexOfData = data.endIndex.advanced(by: -1)
    let lastByteIndexOfData = data.index(before: data.endIndex)
    let lastByteOfData      = data.last
//    var i              = self.startIndex.advanced(by: patternLength - 1)
    var i                   = self.index(self.startIndex, offsetBy: patternLength - 1)

    func reverseMatch() -> Index? {
      var dataIndex = lastByteIndexOfData
      var selfIndex = i
      while dataIndex > data.startIndex {
//        selfIndex = selfIndex.advanced(by: -1)
//        dataIndex = dataIndex.advanced(by: -1)
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
//        i = i.advanced(by: 1)
        i = self.index(after: i)
      } else {
//        i = i.advanced(by: skipTable[byte] ?? patternLength)
        i = self.index(i, offsetBy: skipTable[byte] ?? patternLength)
      }
    }

    return nil
  }
}
