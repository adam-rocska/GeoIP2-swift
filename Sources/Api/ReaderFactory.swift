import Foundation
import class DBReader.MediatorFactory
import protocol DBReader.ReaderFactory

public class ReaderFactory {

  typealias DBReaderFactory = DBReader.ReaderFactory

  private let fileReaderFactory: DBReaderFactory

  init(fileReaderFactory: DBReaderFactory) {
    self.fileReaderFactory = fileReaderFactory
  }

  public convenience init() {
    self.init(fileReaderFactory: DBReader.MediatorFactory())
  }

  public func makeReader<Model>(source: URL, type: DatabaseType) throws -> Reader<Model>? {
    if !source.isFileURL { return nil }
    let reader = try fileReaderFactory.makeInMemoryReader {
      InputStream(url: source) ?? InputStream()
    }
    precondition(reader.metadata.databaseType.contains(type.rawValue))
    return Reader<Model>(dbReader: reader)
  }

}
