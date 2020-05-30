import Foundation
import class DataSection.InMemoryDataSection
import class IndexReader.InMemoryIndex
import class MetadataReader.Reader

class ReaderFactory {
  func makeInMemoryReader(_ inputStream: @escaping () -> InputStream) throws -> Reader {
    let reader = MetadataReader.Reader(windowSize: 2048)
    guard let metadata = reader.read(inputStream()) else { throw ReaderError.cantExtractMetadata }
    let inMemoryIndex       = InMemoryIndex<UInt>(metadata: metadata, stream: inputStream())
    let inMemoryDataSection = InMemoryDataSection(metadata: metadata, stream: inputStream())
    return InMemoryReader(index: inMemoryIndex, dataSection: inMemoryDataSection, metadata: metadata)
  }
}
