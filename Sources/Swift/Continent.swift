import Foundation

struct Continent: ContinentProtocol {
  let code:  String?
  let names: [String: String]?
}

public protocol ContinentProtocol {
  var code:  String? { get }
  var names: [String: String]? { get }
}