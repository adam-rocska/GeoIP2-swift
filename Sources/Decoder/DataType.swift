import Foundation

enum DataType: UInt8 {
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
}
