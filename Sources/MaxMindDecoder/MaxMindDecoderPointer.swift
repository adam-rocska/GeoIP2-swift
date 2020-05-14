import Foundation

public extension MaxMindDecoder {

  func decode(_ data: Data, strayBits: UInt8) -> MaxMindPointer {
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

    if dataSize == 2 { return MaxMindPointer(pointerBase + 2048) }
    if dataSize == 3 { return MaxMindPointer(pointerBase + 526336) }
    return MaxMindPointer(pointerBase)
  }

}
