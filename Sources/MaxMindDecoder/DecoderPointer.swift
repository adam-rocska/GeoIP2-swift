import Foundation

extension Decoder {

  func decode(_ data: Data, strayBits: UInt8) -> OutputData {
    let dataSize = data.count
    precondition(dataSize <= 4 && dataSize >= 1, "Pointer size must be at least 1 byte & at most 4. Got \(dataSize)")

    var pointerBinary: Data
    if dataSize < 4 {
      pointerBinary = Data(count: MemoryLayout<UInt32>.size - dataSize - 1) +
      Data([strayBits]) +
      data
    } else {
      pointerBinary = data
    }

    let pointerBase = input == .big
                      ? UnsafeRawPointer(&pointerBinary).load(as: UInt32.self).bigEndian
                      : UnsafeRawPointer(&pointerBinary).load(as: UInt32.self).littleEndian

    if dataSize == 2 { return OutputData.pointer(pointerBase + 2048) }
    if dataSize == 3 { return OutputData.pointer(pointerBase + 526336) }
    return OutputData.pointer(pointerBase)
  }

}
