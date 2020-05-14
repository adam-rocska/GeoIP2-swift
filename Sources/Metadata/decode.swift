import Foundation
import MaxMindDecoder

func decode(_ data: Data, metadataSectionSize: Int, databaseSize: Int) -> Metadata? {
  guard let iterator = MaxMindIterator(data) else { return nil }
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

  return Metadata(
    nodeCount: nodeCount,
    recordSize: recordSize,
    ipVersion: ipVersion,
    databaseType: databaseType,
    languages: languages,
    binaryFormatMajorVersion: majorVersion,
    binaryFormatMinorVersion: minorVersion,
    buildEpoch: buildEpoch,
    description: description,
    metadataSectionSize: metadataSectionSize,
    databaseSize: databaseSize
  )
}
