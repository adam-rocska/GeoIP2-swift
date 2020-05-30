import Foundation
import struct MetadataReader.Metadata

public protocol Index {

  associatedtype Pointer where Pointer: UnsignedInteger, Pointer: FixedWidthInteger

  init(metadata: Metadata, stream: @autoclosure () -> InputStream)

  func lookup(_ ip: IpAddress) -> Pointer?
}
