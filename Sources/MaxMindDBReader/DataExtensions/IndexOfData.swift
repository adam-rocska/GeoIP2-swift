import Foundation

extension Data {

  fileprivate func boyerMoore(data: Data, from: Index) -> Index? {
    let patternCount = data.count
    precondition(patternCount > 0, "Pattern can't be empty.")
    precondition(count >= patternCount, "Pattern can't be >= than the Data to search in.")
    precondition(indices.contains(from), "Index from which to start the lookup must be contained in the Data.")

    var skipTable = [UInt8: Int]()
    for (i, byte) in data.enumerated() { skipTable[byte] = patternCount - i - 1 }

    let lastIndexOfSelf = endIndex
    let lastIndexOfData = data.index(before: data.endIndex)
    let lastByteOfData  = data.last
    var i               = index(
      from,
      offsetBy: patternCount - 1,
      limitedBy: lastIndexOfSelf
    ) ?? lastIndexOfSelf

    func reverseMatch() -> Index? {
      var dataIndex = lastIndexOfData
      var selfIndex = i
      while dataIndex > data.startIndex {
        selfIndex = index(before: selfIndex)
        dataIndex = index(before: dataIndex)
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
        i = index(after: i)
      } else {
        i = index(
          i,
          offsetBy: skipTable[byte] ?? patternCount,
          limitedBy: lastIndexOfSelf
        ) ?? lastIndexOfSelf
      }
    }
    return nil
  }

  func index(of data: Data) -> Index? {
    return boyerMoore(data: data, from: startIndex)
  }

  func index(of data: Data, from: Index) -> Index? {
    return boyerMoore(data: data, from: from)
  }

  func lastIndex(of data: Data) -> Index? {
    return lastIndex(of: data, from: startIndex)
  }

  func lastIndex(of data: Data, from: Index) -> Index? {
    var last: Index? = from
    while last != nil {
      let next = index(after: last!)
      if !indices.contains(next) { break }
      guard let current = index(of: data, from: next) else { break }
      last = current
    }
    return last == from ? nil : last
  }

}
