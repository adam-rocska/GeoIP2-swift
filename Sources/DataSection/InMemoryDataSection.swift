import Foundation
import Metadata
import MaxMindDecoder

public class InMemoryDataSection: DataSection {

  public static let separator = Data(count: 16)

  let metadata: Metadata

  init(metadata: Metadata) {
    self.metadata = metadata
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

    print("YOLO")

    let dataSectionSize = metadata.dataSectionSize - InMemoryDataSection.separator.count
    let fasz            = UnsafeMutablePointer<UInt8>.allocate(capacity: dataSectionSize)
    let faszRead        = stream.read(fasz, maxLength: dataSectionSize)
    precondition(faszRead == dataSectionSize, "Faszom fasz.")
    let faszData = Data(bytes: fasz, count: faszRead)
    fasz.deallocate()

    let decoder          = MaxMindDecoder(inputEndianness: .big)
    let iterator         = MaxMindIterator(faszData[9696...])!
    let cb: ControlByte? = iterator.next()
    print(cb)
    for byte in faszData[9697...9796] {
      let bits = String(byte, radix: 2)
      let binary = String(repeating: "0", count: 8 - bits.count) + bits
      print ("Byte : \(binary)")
    }
    print(decoder.decode(iterator, as: cb!))

    print("Count : \(faszData.count)")
    print("Node Count            : \(metadata.nodeCount)")
    print("Search tree size      : \(metadata.searchTreeSize)")
    print("Data section size     : \(metadata.dataSectionSize)")
    print("Metadata section size : \(metadata.metadataSectionSize)")
    print("Database size         : \(metadata.databaseSize)")

    stream.close()

    self.init(metadata: metadata)
  }

}
