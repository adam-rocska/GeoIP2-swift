import Foundation

extension Data {

  func limitedIndex(after: Index) -> Index {
    precondition(!self.isEmpty, "limited index accessors can only be performed on non-empty Data.")
    let limitedAfter = index(after: after)
    return indices.contains(limitedAfter)
           ? limitedAfter
           : index(before: endIndex)
  }

  func limitedIndex(before: Index) -> Index {
    precondition(!self.isEmpty, "limited index accessors can only be performed on non-empty Data.")
    if before == startIndex { return startIndex }
    if !indices.contains(before) { return index(before: endIndex) }
    return index(before: before)
  }

  func limitedIndex(_ start: Index, offsetBy: Int) -> Index {
    var offset       = offsetBy
    var currentIndex = start
    while offset != 0 {
      var offsetIndex: Index
      if offset < 0 {
        offsetIndex = limitedIndex(before: currentIndex)
        offset += 1
      } else {
        offsetIndex = limitedIndex(after: currentIndex)
        offset -= 1
      }
      if offsetIndex == currentIndex {
        break
      } else {
        currentIndex = offsetIndex
      }
    }
    return currentIndex
  }

}
