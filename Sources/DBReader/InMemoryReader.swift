import Foundation
import enum Decoder.Payload
import enum IndexReader.IpAddress
import protocol DataSection.DataSection
import protocol IndexReader.Index
import struct MetadataReader.Metadata
import class MetadataReader.Reader
import class IndexReader.InMemoryIndex
import class DataSection.InMemoryDataSection

public class InMemoryReader<SearchIndex>: Reader where SearchIndex: IndexReader.Index {

  private let index:       SearchIndex
  public let  metadata:    Metadata
  private let dataSection: DataSection

  public init(index: SearchIndex, dataSection: DataSection, metadata: Metadata) {
    self.index = index
    self.metadata = metadata
    self.dataSection = dataSection
  }

  convenience init(_ inputStream: @escaping @autoclosure () -> InputStream) throws {
    let reader = MetadataReader.Reader(windowSize: 2048)
    guard let metadata = reader.read(inputStream()) else { throw ReaderError.cantExtractMetadata }
    let inMemoryIndex: SearchIndex = InMemoryIndex<UInt>(metadata: metadata, stream: inputStream())
    let inMemoryDataSection        = InMemoryDataSection(metadata: metadata, stream: inputStream())
    self.init(index: inMemoryIndex, dataSection: inMemoryDataSection, metadata: metadata)
  }

  public func get(_ ip: IpAddress) -> [String: Payload]? {
    guard let lookup = index.lookup(ip) else { return nil }
    guard let lookupResult = dataSection.lookup(pointer: Int(lookup)) else { return nil }
    return lookupResult
  }

}
