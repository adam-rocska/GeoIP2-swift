import Foundation
import Metadata

public protocol IndexProtocol {

  associatedtype Pointer where Pointer: UnsignedInteger, Pointer: FixedWidthInteger

  init(metadata: Metadata, stream: @autoclosure () -> InputStream)

  func lookup(_ ip: IpAddress) -> Pointer?
}
