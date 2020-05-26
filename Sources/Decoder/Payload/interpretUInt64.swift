import Foundation

func interpretUInt64(bytes: Data, sourceEndianness: Endianness) -> Payload? {
  return Payload.uInt64(
    UInt64(
      bytes.padded(for: UInt64.self, as: sourceEndianness),
      sourceEndianness: sourceEndianness
    )
  )
}