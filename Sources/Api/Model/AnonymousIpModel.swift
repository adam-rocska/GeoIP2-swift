import Foundation

public struct AnonymousIpModel {
  let isAnonymous:       Bool
  let isAnonymousVpn:    Bool
  let isHostingProvider: Bool
  let isPublicProxy:     Bool
  let isTorExitNode:     Bool
  let ipAddress:         IpAddress
  let network:           String
}
