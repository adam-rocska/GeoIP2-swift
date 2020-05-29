import Foundation

struct IspModel {
  let autonomousSystemNumber:       Int?
  let autonomousSystemOrganization: String?
  let isp:                          String?
  let organization:                 String?
  let ipAddress:                    IpAddress
  let network:                      String
}
