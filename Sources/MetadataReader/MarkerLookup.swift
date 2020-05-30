import Foundation

class MarkerLookup {
  let marker:    Data
  private let skipTable: [UInt8: Int]

  init(marker: Data) {
    precondition(marker.count > 0, "Marker can't be empty.")
    self.marker = marker

    var skipTable: [UInt8: Int] = [:]
    for (i, byte) in marker.enumerated() { skipTable[byte] = marker.count - i - 1 }
    self.skipTable = skipTable
  }

  private func boyerMoore(window: Data, from: Data.Index) -> Data.Index? {
    precondition(window.indices.contains(from), "Index from which to start the lookup must be contained in the window.")
    if marker.count > window.count { return nil }

    var idx = window.index(
      from,
      offsetBy: marker.count - 1,
      limitedBy: window.endIndex
    ) ?? window.endIndex

    func reverseMatch() -> Data.Index? {
      var markerIndex = marker.index(before: marker.endIndex)
      var windowIndex = idx
      while markerIndex > marker.startIndex {
        windowIndex = window.index(before: windowIndex)
        markerIndex = marker.index(before: markerIndex)
        if window[windowIndex] != marker[markerIndex] { return nil }
      }
      return windowIndex
    }

    while idx < window.endIndex {
      let byte = window[idx]

      if byte == marker.last! {
        if let foundIndex = reverseMatch() {
          return foundIndex
        }
        idx = window.index(after: idx)
      } else {
        idx = window.index(
          idx,
          offsetBy: skipTable[byte] ?? marker.count,
          limitedBy: window.endIndex
        ) ?? window.endIndex
      }
    }
    return nil
  }

  func firstOccurrenceIn(_ data: Data) -> Data.Index? {
    return boyerMoore(window: data, from: data.startIndex)
  }


  func firstOccurrenceIn(_ data: Data, after: Data.Index) -> Data.Index? {
    return boyerMoore(window: data, from: after)
  }

  func lastOccurrenceIn(_ data: Data) -> Data.Index? {
    return lastOccurrenceIn(data, after: data.startIndex)
  }

  func lastOccurrenceIn(_ data: Data, after: Data.Index) -> Data.Index? {
    var last: Data.Index? = after
    while last != nil {
      let next = data.index(after: last!)
      if !data.indices.contains(next) { break }
      guard let current = firstOccurrenceIn(data, after: next) else { break }
      last = current
    }
    return last == after ? nil : last
  }

}
