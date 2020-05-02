import Foundation

public enum ReaderError: Error {
  case cantCreateInputStream(filePath: String)
  case missingMetadata, corruptMetadata
}
