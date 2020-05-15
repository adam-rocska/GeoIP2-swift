import Foundation
import Metadata
import MaxMindDecoder

public class InMemoryDataSection: DataSection {

  public static let separator = Data(count: 16)

  public let  metadata: Metadata
  private let iterator: MaxMindIterator

  init(metadata: Metadata, iterator: MaxMindIterator) {
    self.metadata = metadata
    self.iterator = iterator
  }

  public required convenience init(metadata: Metadata, stream createStream: @autoclosure () -> InputStream) {
    let stream = createStream()
    precondition(stream.streamStatus == Stream.Status.notOpen, "Should have provided an untouched stream.")

    stream.open()

    let searchTreeSize      = Int(metadata.searchTreeSize)
    let skipBuffer          = UnsafeMutablePointer<UInt8>.allocate(capacity: searchTreeSize)
    let skipBufferBytesRead = stream.read(skipBuffer, maxLength: searchTreeSize)
    precondition(skipBufferBytesRead == searchTreeSize, "Metadata mismatches the provided input stream.")
    skipBuffer.deallocate()

    let separatorBuffer          = UnsafeMutablePointer<UInt8>.allocate(capacity: InMemoryDataSection.separator.count)
    let separatorBufferBytesRead = stream.read(separatorBuffer, maxLength: InMemoryDataSection.separator.count)
    precondition(
      separatorBufferBytesRead == InMemoryDataSection.separator.count,
      "Metadata mismatches the provided input stream."
    )
    let separatorBytes = Data(bytesNoCopy: separatorBuffer, count: separatorBufferBytesRead, deallocator: .none)
    precondition(separatorBytes == InMemoryDataSection.separator, "Separator bytes don't match.")
    separatorBuffer.deallocate()

    let dataSectionSize     = metadata.dataSectionSize - InMemoryDataSection.separator.count
    let dataSectionBuffer   = UnsafeMutablePointer<UInt8>.allocate(capacity: dataSectionSize)
    let readDataSectionSize = stream.read(dataSectionBuffer, maxLength: dataSectionSize)
    precondition(readDataSectionSize == dataSectionSize, "Metadata mismatches provided input stream.")
    let dataSectionBinary = Data(bytes: dataSectionBuffer, count: readDataSectionSize)
    dataSectionBuffer.deallocate()

    stream.close()

    self.init(metadata: metadata, iterator: MaxMindIterator(dataSectionBinary)!)
  }

  public func lookup(pointer: Int) -> [String: Any]? {
    iterator.seek(to: pointer)
    guard let mapControlByte = iterator.next() else { return nil }
    if mapControlByte.type != .map { return nil }
    return [:]
  }

}
