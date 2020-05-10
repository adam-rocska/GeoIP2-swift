import Foundation

/**
# Control Byte
Primary source of truth: [MaxMindDB Spec'](https://maxmind.github.io/MaxMind-DB/)
## Data Field Format
Each field starts with a control byte. This control byte provides information
about the field's data type and payload size.

The first three bits of the control byte tell you what type the field is. If
these bits are all 0, then this is an "extended" type, which means that the
*next* byte contains the actual type. Otherwise, the first three bits will
contain a number from 1 to 7, the actual type for the field.

We've tried to assign the most commonly used types as numbers 1-7 as an
optimization.

With an extended type, the type number in the second byte is the number
minus 7. In other words, an array (type 11) will be stored with a 0 for the
type in the first byte and a 4 in the second.

Here is an example of how the control byte may combine with the next byte to
tell us the type:

    001XXXXX          pointer
    010XXXXX          UTF-8 string
    110XXXXX          unsigned 32-bit int (ASCII)
    000XXXXX 00000011 unsigned 128-bit int (binary)
    000XXXXX 00000100 array
    000XXXXX 00000110 end marker

### Payload Size

The next five bits in the control byte tell you how long the data field's
payload is, except for maps and pointers. Maps and pointers use this size
information a bit differently. See below.

If the five bits are smaller than 29, then those bits are the payload size in
bytes. For example:

    01000010          UTF-8 string - 2 bytes long
    01011100          UTF-8 string - 28 bytes long
    11000001          unsigned 32-bit int - 1 byte long
    00000011 00000011 unsigned 128-bit int - 3 bytes long

If the five bits are equal to 29, 30, or 31, then use the following algorithm
to calculate the payload size.

If the value is 29, then the size is 29 + *the next byte after the type
specifying bytes as an unsigned integer*.

If the value is 30, then the size is 285 + *the next two bytes after the type
specifying bytes as a single unsigned integer*.

If the value is 31, then the size is 65,821 + *the next three bytes after the
type specifying bytes as a single unsigned integer*.

Some examples:

    01011101 00110011 UTF-8 string - 80 bytes long

In this case, the last five bits of the control byte equal 29. We treat the
next byte as an unsigned integer. The next byte is 51, so the total size is
(29 + 51) = 80.

    01011110 00110011 00110011 UTF-8 string - 13,392 bytes long

The last five bits of the control byte equal 30. We treat the next two bytes
as a single unsigned integer. The next two bytes equal 13,107, so the total
size is (285 + 13,107) = 13,392.

    01011111 00110011 00110011 00110011 UTF-8 string - 3,421,264 bytes long

The last five bits of the control byte equal 31. We treat the next three bytes
as a single unsigned integer. The next three bytes equal 3,355,443, so the
total size is (65,821 + 3,355,443) = 3,421,264.

This means that the maximum payload size for a single field is 16,843,036
bytes.
 */
public struct ControlByte {

  public let type:           DataType
  public let payloadSize:    UInt32
  let definitionSize: UInt8
  let definition:     Data

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

    self.type = type
    let definitionRange = Range(uncheckedBounds: (
      lower: bytes.startIndex,
      upper: bytes.index(bytes.startIndex, offsetBy: Int(definitionSize))
    ))
    self.definition = bytes.subdata(in: definitionRange)
  }

}
