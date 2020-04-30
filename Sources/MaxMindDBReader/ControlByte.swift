import Foundation

struct ControlByte {

  let type:        DataType
  let payloadSize: UInt32

  init?(bytes: Data) {
    if bytes.count == 0 || bytes.count > 5 { return nil }

    let firstByte                 = bytes.first!
    let typeDefinitionOnFirstByte = firstByte &>> 5

    guard let type = typeDefinitionOnFirstByte != 0b0000_0000
                     ? DataType(rawValue: typeDefinitionOnFirstByte)
                     : DataType(rawValue: bytes[bytes.index(after: bytes.startIndex)] + 7)
      else {
      return nil
    }

    let payloadSizeDefinition = firstByte & 0b0001_1111
    switch payloadSizeDefinition {
      case _ where payloadSizeDefinition < 29:
        payloadSize = UInt32(payloadSizeDefinition)
      default:
        return nil
    }

    self.type = type
  }

}
