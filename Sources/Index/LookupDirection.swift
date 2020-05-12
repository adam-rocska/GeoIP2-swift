import Foundation

enum LookupDirection {
  case left, right

  static func createLookupStack(of byte: UInt8) -> [LookupDirection] {
    return stride(from: 7, through: 0, by: -1)
      .reduce([]) { queue, octet in
        let observerBit = UInt8(0b1000_0000) >> octet
        return queue + [(byte & observerBit) == observerBit
                        ? LookupDirection.right
                        : LookupDirection.left]
      }
  }

  static func createLookupStack(of data: Data) -> [LookupDirection] {
    return data.reversed().reduce([]) { $0 + createLookupStack(of: $1) }
  }

}
