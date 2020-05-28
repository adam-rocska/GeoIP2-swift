import Foundation
import Index
import Metadata

public class InMemoryReader<SearchIndex> where SearchIndex: Index {

  private let index:    SearchIndex
  public let  metadata: Metadata

  init(index: SearchIndex, metadata: Metadata) {
    self.index = index
    self.metadata = metadata
  }

  func get(_ ip: IpAddress) {

  }

}
