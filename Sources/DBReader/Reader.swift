import Foundation
import enum Decoder.Payload
import enum Index.IpAddress
import struct Metadata.Metadata

public protocol Reader {

  var metadata: Metadata { get }

  func get(_ ip: IpAddress) -> [String: Payload]?

}
