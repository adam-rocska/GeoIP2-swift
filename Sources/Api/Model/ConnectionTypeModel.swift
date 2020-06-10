import Foundation
import enum Decoder.Payload

public struct ConnectionTypeModel {
  public let connectionType: String?
  public let ipAddress:      IpAddress
  public let netmask:        IpAddress
}

extension ConnectionTypeModel: DictionaryInitialisableModel {
  public init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.init(
      connectionType: dictionary?["connection_type"]?.unwrap(),
      ipAddress: ip,
      netmask: netmask
    )
  }
}