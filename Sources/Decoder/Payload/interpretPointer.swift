import Foundation

func interpretPointer(
  bytes: Data,
  payloadSize: UInt32,
  strayBits: UInt8,
  sourceEndianness: Endianness,
  resolvePointers: Bool,
  decoder: Decoder
) -> Payload? {
  if !(1...4 ~= payloadSize) { return nil }

  let rawPointer: Data
  if 1...3 ~= payloadSize {
    rawPointer = sourceEndianness == .big ? (Data([strayBits]) + bytes) : (bytes + Data([strayBits]))
  } else {
    rawPointer = bytes
  }

  let magicIncrement: UInt32
  if payloadSize == 2 {
    magicIncrement = 2048
  } else if payloadSize == 3 {
    magicIncrement = 526_336
  } else {
    magicIncrement = 0
  }

  let pointer = UInt32(
    rawPointer.padded(for: UInt32.self, as: sourceEndianness),
    sourceEndianness: sourceEndianness
  ) + magicIncrement

  if resolvePointers { return decoder.read(at: Int(pointer))?.payload }
  return Payload.pointer(pointer)
}
