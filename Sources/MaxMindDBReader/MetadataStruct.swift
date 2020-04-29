import Foundation

struct MetadataStruct: Metadata {
  let nodeCount:                UInt32
  let recordSize:               UInt16
  let ipVersion:                UInt16
  let databaseType:             String
  let languages:                [String]
  let binaryFormatMajorVersion: UInt16
  let binaryFormatMinorVersion: UInt16
  let buildEpoch:               UInt64
  let description:              LanguageToDescription
}
