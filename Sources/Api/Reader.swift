import Foundation
import protocol DBReader.Reader

public class Reader<Model> where Model: DictionaryInitialisable {

  private let dbReader: DBReader.Reader

  init(dbReader: DBReader.Reader) { self.dbReader = dbReader }

  func lookup(_ ip: IpAddress) -> Model? {
    guard let dictionary = dbReader.get(ip) else { return nil }
    return Model.init(dictionary)
  }

}
