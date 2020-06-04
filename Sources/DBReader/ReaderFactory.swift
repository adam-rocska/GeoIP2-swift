import Foundation

public protocol ReaderFactory {
  func makeInMemoryReader(_ inputStream: @escaping () -> InputStream) throws -> Reader
}
