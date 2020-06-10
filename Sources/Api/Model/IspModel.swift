import Foundation
import enum Decoder.Payload

public struct IspModel: Equatable {
  public let autonomousSystemNumber:       Int?
  public let autonomousSystemOrganization: String?
  public let isp:                          String?
  public let organization:                 String?
  public let ipAddress:                    IpAddress
  public let netmask:                      IpAddress
}

extension IspModel: DictionaryInitialisableModel {
  public init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.init(
      autonomousSystemNumber: dictionary?["autonomous_system_number"]?.unwrap(),
      autonomousSystemOrganization: dictionary?["autonomous_system_organization"]?.unwrap(),
      isp: dictionary?["isp"]?.unwrap(),
      organization: dictionary?["organization"]?.unwrap(),
      ipAddress: ip,
      netmask: netmask
    )
  }
}