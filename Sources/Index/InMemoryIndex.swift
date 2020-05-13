import Foundation
import Metadata

class InMemoryIndex<Pointer>: Index where Pointer: UnsignedInteger, Pointer: FixedWidthInteger {

  private let metadata: Metadata
  private let tree:     [Node<Pointer>]

  init(metadata: Metadata, tree: [Node<Pointer>]) {
    self.metadata = metadata
    self.tree = tree
  }

  required convenience init(metadata: Metadata, stream createStream: @autoclosure () -> InputStream) {
    var tree: [Node<Pointer>] = []
    let stream                = createStream()
    precondition(stream.streamStatus == Stream.Status.notOpen, "should have provided an untouched stream.")
    stream.open()
    defer { stream.close() }

    let nodeByteSize = Int(metadata.nodeByteSize)
    while stream.hasBytesAvailable {
      let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: nodeByteSize)
      defer { buffer.deallocate() }

      let read    = stream.read(buffer, maxLength: nodeByteSize)
      tree.append(Node(Data(bytesNoCopy: buffer, count: read, deallocator: .none)))
      if tree.count == metadata.nodeCount { break }
    }

    precondition(tree.count == metadata.nodeCount)


    print("nodeCount                : \(metadata.nodeCount)")
    print("recordSize               : \(metadata.recordSize)")
    print("ipVersion                : \(metadata.ipVersion)")
    print("databaseType             : \(metadata.databaseType)")
    print("languages                : \(metadata.languages)")
    print("binaryFormatMajorVersion : \(metadata.binaryFormatMajorVersion)")
    print("binaryFormatMinorVersion : \(metadata.binaryFormatMinorVersion)")
    print("buildEpoch               : \(metadata.buildEpoch)")
    print("description              : \(metadata.description)")
    print("nodeByteSize             : \(metadata.nodeByteSize)")
    print("searchTreeSize           : \(metadata.searchTreeSize)")
    self.init(metadata: metadata, tree: tree)
  }

  func lookup(_ ip: IpAddress) -> Pointer? {
    var stack = LookupDirection.createLookupStack(of: ip.data)
    return nil
  }

}
