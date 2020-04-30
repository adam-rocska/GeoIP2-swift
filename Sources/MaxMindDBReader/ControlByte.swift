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

    let payloadSizeDefinition = firstByte & 0b0001_1111
    if payloadSizeDefinition < 29 {
      payloadSize = UInt32(payloadSizeDefinition)
    } else {
      let numberOfAdditionalBytesToRead = Int(payloadSizeDefinition & 0b0000_0011)
      let lastIndexOfBytes              = bytes.index(before: bytes.endIndex)
      let sliceFrom                     = bytes.index(
        bytes.startIndex,
        offsetBy: isExtendedType ? 2 : 1,
        limitedBy: lastIndexOfBytes
      ) ?? lastIndexOfBytes
      let sliceTo                       = bytes.index(
        sliceFrom,
        offsetBy: numberOfAdditionalBytesToRead,
        limitedBy: lastIndexOfBytes
      ) ?? lastIndexOfBytes
      let bytesAfterTypeSpecifyingBytes = bytes[sliceFrom...sliceTo]
      let payloadSizeWholeBytes: Data   = bytesAfterTypeSpecifyingBytes + Data(
        count: 4 - bytesAfterTypeSpecifyingBytes.count
      )
      payloadSize = 29 + payloadSizeWholeBytes.withUnsafeBytes { $0.load(as: UInt32.self) }
    }

    self.type = type
  }

}
