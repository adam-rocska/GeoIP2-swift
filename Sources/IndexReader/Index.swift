import Foundation
import struct MetadataReader.Metadata

public protocol Index {

  associatedtype Pointer where Pointer: UnsignedInteger, Pointer: FixedWidthInteger
  typealias LookupResult = (pointer: Pointer, netmask: IpAddress)

  init(metadata: Metadata, stream: @autoclosure () -> InputStream)

  func lookup(_ ip: IpAddress) -> LookupResult?
}
