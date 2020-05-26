import Foundation

func interpretDouble(bytes: Data, sourceEndianness: Endianness) -> Payload? {
  if bytes.count != MemoryLayout<Double>.size { return nil }
  return Payload.double(Double(bytes, sourceEndianness: sourceEndianness))
}