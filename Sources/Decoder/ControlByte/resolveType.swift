import Foundation

func resolveType(bytes: Data, sourceEndianness: Endianness) -> DataType? {
  guard let leadingByte = sourceEndianness == .big ? bytes.first : bytes.last else { return nil }
  let typeDefinition = leadingByte &>> 5
  let isExtendedType = typeDefinition == 0
  if isExtendedType {
    if bytes.count < 2 { return nil }
    let typeByteIndex = sourceEndianness == .big
                        ? bytes.index(after: bytes.startIndex)
                        : bytes.index(before: bytes.index(before: bytes.endIndex))
    return DataType(rawValue: bytes[typeByteIndex] + 7)
  }
  return DataType(rawValue: typeDefinition)
}
