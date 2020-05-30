import Foundation
import enum Decoder.Payload
import struct MetadataReader.Metadata

public protocol DataSection {

  static var separator: Data { get }

  init(metadata: Metadata, stream: @autoclosure () -> InputStream)

  func lookup(pointer: Int) -> [String: Payload]?

}
