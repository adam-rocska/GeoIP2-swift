import Foundation
import Metadata

public protocol DataSection {

  static var separator: Data { get }

  init(metadata: Metadata, stream: @autoclosure () -> InputStream)

}
