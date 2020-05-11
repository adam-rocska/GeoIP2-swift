import Foundation
import MaxMindDecoder

public struct Metadata {
  public let nodeCount:                UInt32
  public let recordSize:               UInt16
  public let ipVersion:                UInt16
  public let databaseType:             String
  public let languages:                [String]
  public let binaryFormatMajorVersion: UInt16
  public let binaryFormatMinorVersion: UInt16
  public let buildEpoch:               UInt64
  public let description:              [String: String]
  public var nodeByteSize:             UInt16 { get { return recordSize / 4 } }
  public var searchTreeSize:           UInt64 { get { return UInt64(nodeCount * UInt32(nodeByteSize)) } }

  public init?(_ iterator: MaxMindIterator) {
    guard let mapControlByte = iterator.next() else { return nil }
    if mapControlByte.type != .map { return nil }
    let decoder = MaxMindDecoder(inputEndianness: .big)

    let decoded: [String: Any] = decoder.decode(iterator, size: Int(mapControlByte.payloadSize))

    guard let nodeCount = decoded["node_count"] as? UInt32 else { return nil }
    guard let recordSize = decoded["record_size"] as? UInt16 else { return nil }
    guard let ipVersion = decoded["ip_version"] as? UInt16 else { return nil }
    guard let databaseType = decoded["database_type"] as? String else { return nil }
    guard let languages = decoded["languages"] as? [String] else { return nil }
    guard let majorVersion = decoded["binary_format_major_version"] as? UInt16 else { return nil }
    guard let minorVersion = decoded["binary_format_minor_version"] as? UInt16 else { return nil }
    guard let buildEpoch = decoded["build_epoch"] as? UInt64 else { return nil }
    guard let description = decoded["description"] as? [String: String] else { return nil }

    self.nodeCount = nodeCount
    self.recordSize = recordSize
    self.ipVersion = ipVersion
    self.databaseType = databaseType
    self.languages = languages
    self.binaryFormatMajorVersion = majorVersion
    self.binaryFormatMinorVersion = minorVersion
    self.buildEpoch = buildEpoch
    self.description = description
  }

  public init?(_ data: Data) {
    guard let iterator = MaxMindIterator(data) else { return nil }
    self.init(iterator)
  }
}
