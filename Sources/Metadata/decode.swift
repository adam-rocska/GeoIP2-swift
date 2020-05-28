import Foundation
import Decoder

func decode(_ data: Data, metadataSectionSize: Int, databaseSize: Int) -> Metadata? {
  if data.isEmpty { return nil }
  let decoder = Decoder(data)
  guard let payload = decoder.read(at: 0) else { return nil }
  guard case let Payload.map(map) = payload else { return nil }

  guard let nodeCount = map["node_count"]?.unwrap() as UInt32? else { return nil }
  guard let recordSize = map["record_size"]?.unwrap() as UInt16? else { return nil }
  guard let ipVersion = map["ip_version"]?.unwrap() as UInt16? else { return nil }
  guard let databaseType = map["database_type"]?.unwrap() as String? else { return nil }
  guard let languages = map["languages"]?.unwrap() as [Payload]? else { return nil }
  guard let majorVersion = map["binary_format_major_version"]?.unwrap() as UInt16? else { return nil }
  guard let minorVersion = map["binary_format_minor_version"]?.unwrap() as UInt16? else { return nil }
  guard let buildEpoch = map["build_epoch"]?.unwrap() as UInt64? else { return nil }
  guard let description = map["description"]?.unwrap() as [String: Payload]? else { return nil }

  return Metadata(
    nodeCount: nodeCount,
    recordSize: recordSize,
    ipVersion: ipVersion,
    databaseType: databaseType,
    languages: languages.compactMap({ $0.unwrap() as String? }),
    binaryFormatMajorVersion: majorVersion,
    binaryFormatMinorVersion: minorVersion,
    buildEpoch: buildEpoch,
    description: description.compactMapValues({ $0.unwrap() as String? }),
    metadataSectionSize: metadataSectionSize,
    databaseSize: databaseSize
  )
}
