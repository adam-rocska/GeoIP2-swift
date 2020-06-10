import Foundation
import enum Decoder.Payload
import enum IndexReader.IpAddress
import protocol DataSection.DataSection
import protocol IndexReader.Index
import struct MetadataReader.Metadata

class Mediator<SearchIndex>: Reader where SearchIndex: IndexReader.Index {

  private let index:       SearchIndex
  public let  metadata:    Metadata
  private let dataSection: DataSection

  public init(index: SearchIndex, dataSection: DataSection, metadata: Metadata) {
    self.index = index
    self.metadata = metadata
    self.dataSection = dataSection
  }

  public func get(_ ip: IpAddress) -> LookupResult? {
    guard let indexLookupResult = index.lookup(ip) else { return nil }
    let dataSectionPointer = indexLookupResult.pointer - SearchIndex.Pointer(metadata.nodeCount) - 16
    guard let dataLookupResult = dataSection.lookup(pointer: Int(dataSectionPointer)) else { return nil }
    return (dataLookupResult, indexLookupResult.netmask)
  }

}
