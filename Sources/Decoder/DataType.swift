import Foundation

enum DataType: UInt8, CaseIterable {

  case pointer            = 1
  case utf8String         = 2
  case double             = 3
  case bytes              = 4
  case uInt16             = 5
  case uInt32             = 6
  case map                = 7
  case int32              = 8
  case uInt64             = 9
  case uInt128            = 10
  case array              = 11
  case dataCacheContainer = 12
  case endMarker          = 13
  case boolean            = 14
  case float              = 15

  var isExtendedType: Bool { get { return self.rawValue > 7 } }

  init?(_ data: Foundation.Data) {
    guard let firstByte = data.first else { return nil }
    let firstByteTypeMarker = firstByte &>> 5

    let rawValueCandidate: UInt8
    if firstByteTypeMarker == 0 {
      let lastByteIndex = data.index(before: data.endIndex)
      guard let secondByteIndex = data.index(data.startIndex, offsetBy: 1, limitedBy: lastByteIndex) else { return nil }
      if data[secondByteIndex] > UInt8.max - 7 { return nil }
      rawValueCandidate = data[secondByteIndex] + 7
    } else {
      rawValueCandidate = firstByteTypeMarker
    }

    guard let dataType = DataType(rawValue: rawValueCandidate) else { return nil }
    self = dataType
  }

}
