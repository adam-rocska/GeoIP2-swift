import Foundation

func interpretInt32(bytes: Data, sourceEndianness: Endianness) -> Payload? {
  return Payload.int32(
    Int32(
      bytes.padded(for: Int32.self, as: sourceEndianness),
      sourceEndianness: sourceEndianness
    )
  )
}
