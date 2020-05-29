import Foundation

protocol ReaderFileBased: Reader {
  var metadata: DbMetadata { get }
}
