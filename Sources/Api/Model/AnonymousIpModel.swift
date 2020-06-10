import Foundation
import enum Decoder.Payload

public struct AnonymousIpModel: Equatable {
  public let isAnonymous:       Bool
  public let isAnonymousVpn:    Bool
  public let isHostingProvider: Bool
  public let isPublicProxy:     Bool
  public let isTorExitNode:     Bool
  public let ipAddress:         IpAddress
  public let netmask:           IpAddress
}

extension AnonymousIpModel: DictionaryInitialisableModel {
  public init(ip: IpAddress, netmask: IpAddress, _ dictionary: [String: Payload]?) {
    self.init(
      isAnonymous: dictionary?["is_anonymous"]?.unwrap() ?? false,
      isAnonymousVpn: dictionary?["is_anonymous_vpn"]?.unwrap() ?? false,
      isHostingProvider: dictionary?["is_hosting_provider"]?.unwrap() ?? false,
      isPublicProxy: dictionary?["is_public_proxy"]?.unwrap() ?? false,
      isTorExitNode: dictionary?["is_tor_exit_node"]?.unwrap() ?? false,
      ipAddress: ip,
      netmask: netmask
    )
  }


}