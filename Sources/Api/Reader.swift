import Foundation
import protocol DBReader.Reader

public class Reader<Model> where Model: DictionaryInitialisableModel {

  private let dbReader: DBReader.Reader

  init(dbReader: DBReader.Reader) { self.dbReader = dbReader }

  public func lookup(_ ip: IpAddress) -> Model? {
    guard let lookupResult = dbReader.get(ip) else { return nil }
    return Model.init(ip: ip, netmask: lookupResult.netmask, lookupResult.record)
  }

}
