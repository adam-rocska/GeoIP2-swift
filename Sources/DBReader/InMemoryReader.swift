import Foundation
import enum Decoder.Payload
import enum Index.IpAddress
import protocol DataSection.DataSection
import protocol Index.Index
import struct Metadata.Metadata

public class InMemoryReader<SearchIndex>: Reader where SearchIndex: Index {

  private let index:       SearchIndex
  public let  metadata:    Metadata
  private let dataSection: DataSection

  public init(index: SearchIndex, dataSection: DataSection, metadata: Metadata) {
    self.index = index
    self.metadata = metadata
    self.dataSection = dataSection
  }

  public func get(_ ip: IpAddress) -> [String: Payload]? {
    guard let lookup = index.lookup(ip) else { return nil }
    guard let lookupResult = dataSection.lookup(pointer: Int(lookup)) else { return nil }
    return lookupResult
  }

}
