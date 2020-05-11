import Foundation

public protocol Metadata {

  var nodeCount:                UInt32 { get }
  var recordSize:               UInt16 { get }
  var ipVersion:                UInt16 { get }
  var databaseType:             String { get }
  var languages:                [String] { get }
  var binaryFormatMajorVersion: UInt16 { get }
  var binaryFormatMinorVersion: UInt16 { get }
  var buildEpoch:               UInt64 { get }
  var description:              [String:String] { get }
  var nodeByteSize:             UInt16 { get }
  var searchTreeSize:           UInt64 { get }

}