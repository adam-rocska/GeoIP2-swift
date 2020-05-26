import Foundation

func resolvePayloadSize(dataType: DataType, bytes: Data, sourceEndianness: Endianness) -> UInt32? {
  func endianBased<T>(_ a: T, _ b: T) -> T { return sourceEndianness == .big ? a : b }

  guard let leadingByte = endianBased(bytes.first, bytes.last) else { return nil }
  let initialSizeDefinition = leadingByte & 0b0001_1111
  if dataType == .pointer {
    return UInt32((initialSizeDefinition &>> 3) + 1)
  }

  let getDataSlice = { (numberOfBytesToFetch: Int) -> Data? in
    let startOffset = dataType.isExtended ? 2 : 1
    if bytes.count < startOffset + numberOfBytesToFetch { return nil }
    guard let sliceStart = bytes.index(
      endianBased(bytes.startIndex, bytes.endIndex),
      offsetBy: endianBased(startOffset, -startOffset),
      limitedBy: endianBased(bytes.endIndex, bytes.startIndex)
    ) else { return nil }

    guard let sliceEnd = bytes.index(
      sliceStart,
      offsetBy: endianBased(numberOfBytesToFetch, -numberOfBytesToFetch),
      limitedBy: endianBased(bytes.endIndex, bytes.startIndex)
    ) else { return nil }

    return bytes.subdata(
      in: Range(
        uncheckedBounds: (
          lower: endianBased(sliceStart, sliceEnd),
          upper: endianBased(sliceEnd, sliceStart)
        )
      )
    )
  }

  let specialRepresentation: (bytesToSlice: Int, increment: UInt32)
  switch initialSizeDefinition {
    case 29: specialRepresentation = (1, 29)
    case 30: specialRepresentation = (2, 285)
    case 31: specialRepresentation = (3, 65_821)
    default: return UInt32(initialSizeDefinition)
  }
  guard let dataSlice = getDataSlice(specialRepresentation.bytesToSlice) else { return nil }
  return UInt32(
    dataSlice.padded(for: UInt32.self, as: sourceEndianness),
    sourceEndianness: sourceEndianness
  ) + specialRepresentation.increment
}