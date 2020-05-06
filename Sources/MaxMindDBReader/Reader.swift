import Foundation

public class Reader {

  static let dataSectionSeparator      = Data(count: 16)
  static let metadataStartMarker: Data = Data([0xAB, 0xCD, 0xEF]) +
                                         Data("MaxMind.com".utf8)

  private let databaseContent: Data
  let metadata: Metadata

  public init(data: Data) throws {
    databaseContent = data
    guard let metaIndex = databaseContent.lastIndex(of: Reader.metadataStartMarker) else {
      throw ReaderError.missingMetadata
    }
    guard let metaStartIndex = databaseContent.index(
      metaIndex,
      offsetBy: Reader.metadataStartMarker.count,
      limitedBy: databaseContent.endIndex
    ) else {
      throw ReaderError.corruptMetadata
    }

    let metadataRange = Range(uncheckedBounds: (
      lower: metaStartIndex,
      upper: databaseContent.endIndex
    ))
    let rawMetadata   = databaseContent.subdata(in: metadataRange)
    guard let metadata = MetadataStruct(rawMetadata) else {
      throw ReaderError.corruptMetadata
    }

    self.metadata = metadata
  }

  public convenience init(fileAtPath: String) throws {
    guard let inputStream = InputStream(fileAtPath: fileAtPath) else {
      throw ReaderError.cantCreateInputStream(filePath: fileAtPath)
    }
    try self.init(data: Data(inputStream: inputStream))
  }

}
