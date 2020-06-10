import Foundation
import enum Decoder.Payload

public struct TraitsRecord: Equatable {
  let autonomousSystemNumber:       Int?
  let autonomousSystemOrganization: String?
  let connectionType:               String?
  let domain:                       String?
  // todo
//  let ipAddress:                    IpAddress
  let isAnonymous:                  Bool
  let isAnonymousProxy:             Bool
  let isAnonymousVpn:               Bool
  let isHostingProvider:            Bool
  let isLegitimateProxy:            Bool
  let isPublicProxy:                Bool
  let isSatelliteProvider:          Bool
  let isTorExitNode:                Bool
  let isp:                          String?
  let network:                      String
  let organization:                 String?
  let staticIPScore:                Float?
  let userCount:                    Int?
  let userType:                     String?
}

extension TraitsRecord: DictionaryInitialisableRecord {
  public init(_ dictionary: [String: Payload]?) {
    self.init(
      autonomousSystemNumber: dictionary?["autonomous_system_number"]?.unwrap(),
      autonomousSystemOrganization: dictionary?["autonomous_system_organization"]?.unwrap(),
      connectionType: dictionary?["connection_type"]?.unwrap(),
      domain: dictionary?["domain"]?.unwrap(),
      // TODO
//      ipAddress: dictionary?["ipAddress"]?.unwrap(),
      isAnonymous: dictionary?["is_anonymous"]?.unwrap() ?? false,
      isAnonymousProxy: dictionary?["is_anonymous_proxy"]?.unwrap() ?? false,
      isAnonymousVpn: dictionary?["is_anonymous_vpn"]?.unwrap() ?? false,
      isHostingProvider: dictionary?["is_hosting_provider"]?.unwrap() ?? false,
      isLegitimateProxy: dictionary?["is_legitimate_proxy"]?.unwrap() ?? false,
      isPublicProxy: dictionary?["is_public_proxy"]?.unwrap() ?? false,
      isSatelliteProvider: dictionary?["is_satellite_provider"]?.unwrap() ?? false,
      isTorExitNode: dictionary?["is_tor_exit_node"]?.unwrap() ?? false,
      isp: dictionary?["isp"]?.unwrap(),
      // TODO
      network: dictionary?["network"]?.unwrap() ?? "",
      organization: dictionary?["organization"]?.unwrap(),
      staticIPScore: dictionary?["static_ip_score"]?.unwrap(),
      userCount: dictionary?["user_count"]?.unwrap(),
      userType: dictionary?["user_type"]?.unwrap()
    )
  }


}