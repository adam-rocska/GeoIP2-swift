import Foundation
import enum Decoder.Payload

public protocol DictionaryInitialisableModel {

  var ipAddress: IpAddress { get }
  var netmask:   IpAddress { get }

  init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?)

}

public protocol DictionaryInitialisableRecord {
  init(_ dictionary: [String: Payload]?)
}
