import Foundation
import Index
import Metadata
import DataSection

public class InMemoryReader<SearchIndex> where SearchIndex: Index {

  private let index:       SearchIndex
  public let  metadata:    Metadata
  private let dataSection: DataSection

  init(index: SearchIndex, dataSection: DataSection, metadata: Metadata) {
    self.index = index
    self.metadata = metadata
    self.dataSection = dataSection
  }

  func get(_ ip: IpAddress) -> Payload? {
    guard let lookup = index.lookup(ip) else { return nil }
  }

}
