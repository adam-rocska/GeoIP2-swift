import Foundation
import Metadata
import Decoder

public protocol DataSection {

  static var separator: Data { get }

  init(metadata: Metadata, stream: @autoclosure () -> InputStream)

  func lookup(pointer: Int) -> [String: Payload]?

}
