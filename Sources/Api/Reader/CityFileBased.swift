import Foundation
import protocol DBReader.Reader

public class CityFileBased {

  static let databaseType = DatabaseType.city

  let dbReader: DBReader.Reader
  public var metadata: DbMetadata { get { return dbReader.metadata } }

  public init(dbReader: Reader) {
    precondition(dbReader.metadata.databaseType == CityFileBased.databaseType.rawValue)
    self.dbReader = dbReader
  }

  public func lookup(_ ip: IpAddress) -> CityModel? {
    guard let dictionary = dbReader.get(ip) else { return nil }
    return nil
  }
}
