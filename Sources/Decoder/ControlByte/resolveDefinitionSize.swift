import Foundation

func resolveDefinitionSize(dataType: DataType, bytes: Data, sourceEndianness: Endianness) -> UInt8? {
  guard let leadingByte = sourceEndianness == .big ? bytes.first : bytes.last else { return nil }
  if dataType == .pointer { return 1 }
  let baseSize: UInt8 = dataType.isExtended ? 2 : 1
  return baseSize + (leadingByte & 0b0000_0011)
}
