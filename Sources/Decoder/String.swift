import Foundation

internal extension String {

  init?(_ data: Data) { self.init(bytes: data, encoding: .utf8) }

}