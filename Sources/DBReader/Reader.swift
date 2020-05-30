import Foundation
import enum Decoder.Payload
import enum IndexReader.IpAddress
import struct MetadataReader.Metadata

public protocol Reader {

  var metadata: Metadata { get }

  func get(_ ip: IpAddress) -> [String: Payload]?

}
