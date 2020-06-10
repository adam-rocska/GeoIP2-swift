import Foundation
import enum Decoder.Payload
import enum IndexReader.IpAddress
import struct MetadataReader.Metadata

public protocol Reader {

  typealias LookupResult = (record: [String: Payload], netmask: IpAddress)

  var metadata: Metadata { get }

  func get(_ ip: IpAddress) -> LookupResult?

}
