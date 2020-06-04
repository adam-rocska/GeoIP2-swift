import Foundation

public enum DatabaseType: String {
  case city           = "City"
  case country        = "Country"
  case anonymousIp    = "GeoIP2-Anonymous-IP"
  case asn            = "GeoLite2-ASN"
  case connectionType = "GeoIP2-Connection-Type"
  case domain         = "GeoIP2-Domain"
  case enterprise     = "Enterprise"
  case isp            = "GeoIP2-ISP"
}
