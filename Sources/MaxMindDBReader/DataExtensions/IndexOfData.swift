import Foundation

extension Data {

  fileprivate func boyerMoore(data: Data, from: Index) -> Index? {
    let patternLength = data.count
    precondition(patternLength > 0, "Pattern can't be empty.")
    precondition(self.count >= patternLength, "Pattern can't be >= than the Data to search in.")
    precondition(self.indices.contains(from), "Index from which to start the lookup must be contained in the Data.")

    var skipTable = [UInt8: Int]()
    for (i, byte) in data.enumerated() {
      skipTable[byte] = patternLength - i - 1
    }

    let lastIndexOfSelf = self.endIndex
    let lastIndexOfData = data.index(before: data.endIndex)
    let lastByteOfData  = data.last
    var i               = self.index(from, offsetBy: patternLength - 1, limitedBy: lastIndexOfSelf) ?? lastIndexOfSelf

    func reverseMatch() -> Index? {
      var dataIndex = lastIndexOfData
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
          limitedBy: lastIndexOfSelf
        ) ?? lastIndexOfSelf
      }
    }
    return nil
  }

  func index(of data: Data) -> Index? {
    return boyerMoore(data: data, from: self.startIndex)
  }

  func index(of data: Data, from: Index) -> Index? {
    return boyerMoore(data: data, from: from)
  }

  func lastIndex(of data: Data) -> Index? {
    var lastIndexOfData:Index? = index(of: data)
    while lastIndexOfData != nil {
      lastIndexOfData = index(
        of: data,
        from: self.index(after: lastIndexOfData!)
      )
    }
    return lastIndexOfData
  }

}
