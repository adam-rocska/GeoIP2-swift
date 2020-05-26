import Foundation

func interpretUInt32(bytes: Data, sourceEndianness: Endianness) -> Payload? {
  return Payload.uInt32(
    UInt32(
      bytes.padded(for: UInt32.self, as: sourceEndianness),
      sourceEndianness: sourceEndianness
    )
  )
}