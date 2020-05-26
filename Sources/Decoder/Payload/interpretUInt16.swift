import Foundation

func interpretUInt16(bytes: Data, sourceEndianness: Endianness) -> Payload? {
  return Payload.uInt16(
    UInt16(
      bytes.padded(for: UInt16.self, as: sourceEndianness),
      sourceEndianness: sourceEndianness
    )
  )
}