import Foundation

enum InputData {
  case pointer(bytes: Data, strayBits: UInt8)
  case utf8String(bytes: Data)
  case double(bytes: Data)
}
