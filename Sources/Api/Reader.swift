import Foundation

public protocol Reader {

  associatedtype Model

  func lookup(_ ip: IpAddress) -> Model

}
