import Foundation

public enum ReaderError: Error {
  case cantCreateInputStream(filePath: String)
}
