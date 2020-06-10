import Foundation
import enum Decoder.Payload

public struct AsnModel {
  public let autonomousSystemNumber:       UInt32?
  public let autonomousSystemOrganization: String?
  public let ipAddress:                    IpAddress
  public let netmask:                      IpAddress
}

extension AsnModel: DictionaryInitialisableModel {
  public init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.init(
      autonomousSystemNumber:dictionary?["autonomous_system_number"]?.unwrap(),
      autonomousSystemOrganization:dictionary?["autonomous_system_organization"]?.unwrap(),
      ipAddress: ip,
      netmask: netmask
    )
  }
}