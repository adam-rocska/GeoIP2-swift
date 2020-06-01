import Foundation
import struct MetadataReader.Metadata

public class InMemoryIndex<Pointer>: Index where Pointer: UnsignedInteger, Pointer: FixedWidthInteger {

  private let metadata: Metadata
  private let tree:     Data

  init(metadata: Metadata, tree: Data) {
    self.metadata = metadata
    self.tree = tree
  }

  required public convenience init(metadata: Metadata, stream createStream: @autoclosure () -> InputStream) {
    precondition(
      metadata.recordSize < (MemoryLayout<Pointer>.size * 8),
      "Can't fit record size of \(metadata.recordSize) bits in \(Pointer.self)'s \(MemoryLayout<Pointer>.size) bytes."
    )
    let stream = createStream()
    precondition(stream.streamStatus == Stream.Status.notOpen, "Should have provided an untouched stream.")
    let searchTreeSize = Int(metadata.searchTreeSize)
    stream.open()
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: searchTreeSize)
    let read   = stream.read(buffer, maxLength: searchTreeSize)

    buffer.deallocate()
    stream.close()
//    precondition(tree.count == metadata.nodeCount)
    self.init(metadata: metadata, tree: Data(
      bytesNoCopy: buffer,
      count: read,
      deallocator: .none
    ))
  }

  public func lookup(_ ip: IpAddress) -> Pointer? {
    var stack: [LookupDirection]
    if ip.version == metadata.ipVersion {
      stack = LookupDirection.createLookupStack(of: ip.data)
    } else if metadata.ipVersion == 6 {
      stack = LookupDirection.createLookupStack(of: IpAddress.v6(ip).data)
    } else {
      preconditionFailure("Can't look up IPv6 in an IPv4 database.")
    }
    var pointer: Pointer = 0

    let nodeByteSize = Pointer.init(metadata.nodeByteSize)
    while pointer < metadata.nodeCount {
      guard let direction = stack.popLast() else { break }
      let pointerInTree = pointer * nodeByteSize
      let nodeCandidate = tree[pointerInTree..<pointerInTree + nodeByteSize]
      let node = Node<Pointer>(nodeCandidate)
//      guard let node = tree[pointer] else { return pointer }

      switch direction {
        case .left: pointer = node.left
        case .right: pointer = node.right
      }

      if pointer == metadata.nodeCount {
        return nil
      } else if pointer > metadata.nodeCount {
        return pointer
      }
    }
    return nil
  }

}
