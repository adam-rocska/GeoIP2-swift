import Foundation

public struct ControlByte: Equatable {

  public let type:        DataType
  public let payloadSize: UInt32
  var strayBits:      UInt8 {
    get {
      precondition(type == DataType.pointer)
      return definition.first! & 0b0000_0111
    }
  }
  let definitionSize: UInt8
  let definition:     Data

  private init(type: DataType, payloadSize: UInt32, definitionSize: UInt8, definition: Data) {
    self.type = type
    self.payloadSize = payloadSize
    self.definitionSize = definitionSize
    self.definition = definition
  }

  init?(bytes: Data) {
    if bytes.count == 0 || bytes.count > 5 { return nil }

    let firstByte                 = bytes.first!
    let typeDefinitionOnFirstByte = firstByte &>> 5
    let isExtendedType            = typeDefinitionOnFirstByte == 0b0000_0000

    let payloadSize:    UInt32
    let definitionSize: UInt8

    guard let type = isExtendedType
                     ? DataType(rawValue: bytes[bytes.index(after: bytes.startIndex)] + 7)
                     : DataType(rawValue: typeDefinitionOnFirstByte)
      else {
      return nil
    }

    let payloadSizeDefinition = firstByte & 0b0001_1111
    // Thank this logic to the php scripters that designed the database.
    // TODO : Try to refactor at some point somehow this pile of 💩
    if type == DataType.pointer {
      definitionSize = 1
      payloadSize = UInt32(payloadSizeDefinition &>> 3) + 1
    } else if payloadSizeDefinition < 29 {
      payloadSize = UInt32(payloadSizeDefinition)
      definitionSize = isExtendedType ? 2 : 1
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

      let val = (0..<numberOfAdditionalBytesToRead)
        .map({ Int($0) })
        .reduce(UInt32(28)) { previous, byteCount in
          precondition(byteCount <= 4)
          let payloadSizeBase = Data(repeating: 0b1111_1111, count: byteCount) +
                                Data(count: 4 - byteCount)
          return (previous + 1) + payloadSizeBase.withUnsafeBytes { $0.load(as: UInt32.self) }
        }

      payloadSize = UInt32(val) + payloadSizeWholeBytes.withUnsafeBytes { $0.load(as: UInt32.self) }
      definitionSize = (isExtendedType ? 2 : 1) + payloadSizeDefinition & 0b0000_0011
    }

    let definitionRange = Range(uncheckedBounds: (
      lower: bytes.startIndex,
      upper: bytes.index(bytes.startIndex, offsetBy: Int(definitionSize))
    ))

    self.init(
      type: type,
      payloadSize: payloadSize,
      definitionSize: definitionSize,
      definition: bytes.subdata(in: definitionRange)
    )
  }

}
