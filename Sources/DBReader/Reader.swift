import Foundation
import enum Decoder.Payload
import enum Index.IpAddress

protocol Reader {

  func get(_ ip: IpAddress) -> [String: Payload]?

}
