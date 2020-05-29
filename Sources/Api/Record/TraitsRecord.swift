import Foundation

struct TraitsRecord {
  let autonomousSystemNumber:       Int?
  let autonomousSystemOrganization: String?
  let connectionType:               String?
  let domain:                       String?
  let ipAddress:                    IpAddress
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
