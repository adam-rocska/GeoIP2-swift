import Foundation
import MaxMindDecoder

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

    var metadataSection: Data?       = nil
    var previousData:    Data?       = nil
    var pIdx:            Data.Index? = nil

    while stream.hasBytesAvailable {
      let read        = stream.read(buffer, maxLength: bufferSize)
      let currentData = Data(bytes: buffer, count: read)
      defer { previousData = currentData }
      if previousData == nil { continue }

      let dataChain: Data = previousData! + currentData
      metadataSection?.append(currentData)

      guard let idx = markerLookup.lastOccurrenceIn(dataChain) else { continue }
      if pIdx != nil && (pIdx! - bufferSize) == idx { continue }
      pIdx = idx
      metadataSection = Data(capacity: Reader.maximumMetadataSize)
      let metadataSliceStart = dataChain.index(
        idx,
        offsetBy: markerLookup.marker.count
      )
      metadataSection?.append(dataChain[metadataSliceStart...])
    }

    if metadataSection == nil { return nil }

    let metadata = Metadata(metadataSection!)

    return nil
  }

}
