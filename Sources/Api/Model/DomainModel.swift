import Foundation
import enum Decoder.Payload

public struct DomainModel {
  public let domain:    String?
  public let ipAddress: IpAddress
  public let netmask:   IpAddress
}

extension DomainModel: DictionaryInitialisableModel {
  public init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.init(
      domain: dictionary?["domain"]?.unwrap(),
      ipAddress: ip,
      netmask: netmask
    )
  }
}