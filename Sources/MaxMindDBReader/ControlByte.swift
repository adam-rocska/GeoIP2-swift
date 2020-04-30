import Foundation

struct ControlByte {

  let type:        DataType
  let payloadSize: UInt32

  init?(bytes: Data) {
    if bytes.count == 0 || bytes.count > 5 { return nil }

    let firstByte                 = bytes.first!
    let typeDefinitionOnFirstByte = firstByte &>> 5
    let isExtendedType            = typeDefinitionOnFirstByte == 0b0000_0000

    guard let type = isExtendedType
                     ? DataType(rawValue: bytes[bytes.index(after: bytes.startIndex)] + 7)
                     : DataType(rawValue: typeDefinitionOnFirstByte)
      else {
      return nil
    }

    let sliceFrom = bytes.index(
      bytes.startIndex,
      offsetBy: isExtendedType ? 2 : 1,
      limitedBy: bytes.endIndex
    ) ?? bytes.startIndex

    let bytesAfterTypeSpecifyingBytes = bytes[sliceFrom...]

    let payloadSizeDefinition = firstByte & 0b0001_1111
    switch payloadSizeDefinition {
      case _ where payloadSizeDefinition < 29:
        payloadSize = UInt32(payloadSizeDefinition)
      case 29:
        payloadSize = 29 + UInt32(bytesAfterTypeSpecifyingBytes.first ?? 0)
      default:
        return nil
    }

    self.type = type
  }

}
