import Foundation

public class Reader {

  static let metadataStartMarker: Data = Data([0xAB, 0xCD, 0xEF]) +
                                         Data("MaxMind.com".utf8)

  public static let maximumMetadataSize = 128 * 1024 // 128 KiB

  let bufferSize: Int
  let windowSize: Int
  private let markerLookup: MarkerLookup

  public init(windowSize: Int) {
    self.windowSize = windowSize
    self.bufferSize = windowSize / 2
    self.markerLookup = MarkerLookup(marker: Reader.metadataStartMarker)
  }

  public func read(_ stream: InputStream) -> Metadata? {
    precondition(stream.streamStatus == Stream.Status.notOpen, "The input stream must be new & fresh.")
    stream.open()
    defer { stream.close() }

    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    defer { buffer.deallocate() }

    var metadataSection: Data? = nil
    var previousData:    Data? = nil

    while stream.hasBytesAvailable {
      let read        = stream.read(buffer, maxLength: bufferSize)
      let currentData = Data(bytes: buffer, count: read)
      if previousData != nil {
        let dataChain:Data = previousData! + currentData
        metadataSection?.append(dataChain)
        if let idx = markerLookup.lastOccurrenceIn(dataChain) {
          metadataSection = Data(capacity: Reader.maximumMetadataSize)
          metadataSection?.append(dataChain[idx...])
        }
      }
      previousData = currentData
    }

    print(metadataSection)

    return nil
  }

}
