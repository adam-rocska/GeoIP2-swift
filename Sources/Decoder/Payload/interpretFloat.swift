import Foundation

func interpretFloat(bytes: Data, sourceEndianness: Endianness) -> Payload? {
  if bytes.count != MemoryLayout<Float>.size { return nil }
  return Payload.float(Float(bytes, sourceEndianness: sourceEndianness))
}
