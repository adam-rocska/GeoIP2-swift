import Foundation
import MaxMindDecoder

public struct Metadata: Equatable {

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

  public var dataSectionSize:     Int { get { return databaseSize - metadataSectionSize - Int(searchTreeSize) } }
  public let metadataSectionSize: Int
  public let databaseSize:        Int

}
