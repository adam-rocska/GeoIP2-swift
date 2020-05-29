import Foundation
import Index
import Metadata
import DataSection
import Decoder

public class InMemoryReader<SearchIndex> where SearchIndex: IndexProtocol {

  private let index:       SearchIndex
  public let  metadata:    Metadata
  private let dataSection: DataSection

  init(index: SearchIndex, dataSection: DataSection, metadata: Metadata) {
    self.index = index
    self.metadata = metadata
    self.dataSection = dataSection
  }

  func get(_ ip: IpAddress) -> [String: Payload]? {
    guard let lookup = index.lookup(ip) else { return nil }
    guard let lookupResult = dataSection.lookup(pointer: Int(lookup)) else { return nil }
    return lookupResult
  }

}
