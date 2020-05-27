import Foundation

func resolveDefinitionSize(dataType: DataType, bytes: Data, sourceEndianness: Endianness) -> UInt8? {
  guard let leadingByte = sourceEndianness == .big ? bytes.first : bytes.last else { return nil }
  if dataType == .pointer { return 1 }
  let baseSize: UInt8 = dataType.isExtended ? 2 : 1
  switch leadingByte & 0b0001_1111 {
    case 29: return baseSize + 1
    case 30: return baseSize + 2
    case 31: return baseSize + 3
    default: return baseSize
  }
}
