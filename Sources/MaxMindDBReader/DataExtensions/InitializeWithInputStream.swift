import Foundation

extension Data {
  init(inputStream: InputStream) {
    self.init()

    inputStream.open()
    defer { inputStream.close() }

    let bufferSize = 1024
    let buffer     = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    defer { buffer.deallocate() }

    while inputStream.hasBytesAvailable {
      let read = inputStream.read(buffer, maxLength: bufferSize)
      self.append(buffer, count: read)
    }
  }
}
