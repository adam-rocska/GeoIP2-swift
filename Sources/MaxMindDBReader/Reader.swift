import Foundation

public class Reader {

  private let dataSectionSeparatorSize = 16
  static let  metadataStartMarker      = Data([
                                                UInt8(0xAB),
                                                UInt8(0xCD),
                                                UInt8(0xEF)
                                              ]) + Data("MaxMind.com".utf8)

  private let metadataMaxSize = 128 * 1024; // 128KiB
  private let databaseContent: Data

  init(data: Data) {
    databaseContent = data
  }

  convenience init(fileAtPath: String) throws {
    guard let inputStream = InputStream(fileAtPath: fileAtPath) else {
      throw ReaderError.cantCreateInputStream(filePath: fileAtPath)
    }
    self.init(data: Data(inputStream: inputStream))
  }

  private static func findMetadataStart(database: Data) {

  }

}
