import Foundation

public struct AsnModel {
  let autonomousSystemNumber:       Int?
  let autonomousSystemOrganization: String?
  let ipAddress:                    IpAddress
  let network:                      String
}
