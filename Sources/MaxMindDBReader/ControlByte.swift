import Foundation

struct ControlByte {

  let type: DataType

  init?(firstByte: UInt8, secondByte: UInt8 = 0b0000_0000) {
    let typeDefinitionOnFirstByte = firstByte &>> 5
    guard let type = typeDefinitionOnFirstByte != 0b0000_0000
                     ? DataType(rawValue: typeDefinitionOnFirstByte)
                     : DataType(rawValue: secondByte + 7)
      else {
      return nil
    }
    self.type = type
  }
}
