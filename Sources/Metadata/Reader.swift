import Foundation

public class Reader {

  static let metadataStartMarker: Data = Data([0xAB, 0xCD, 0xEF]) +
                                         Data("MaxMind.com".utf8)

  public static let maximumMetadataSize = 128 * 1024 // 128 KiB

  let readBufferSize: Int
  let windowSize:     Int
  private let markerLookup: MarkerLookup

  public init(windowSize: Int) {
    self.windowSize = windowSize
    self.readBufferSize = windowSize / 2
    self.markerLookup = MarkerLookup(marker: Reader.metadataStartMarker)
  }

//  public func read(_ stream: InputStream) -> Metadata {
//    precondition(stream.streamStatus == Stream.Status.notOpen, "The input stream must be new & fresh.")
//    stream.open()
//    defer { stream.close() }
//
//    let window     = Data(capacity: windowSize)
//    let readBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: readBufferSize)
//    while stream.hasBytesAvailable {
//
//    }
//  }

}
