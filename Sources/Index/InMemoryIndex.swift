import Foundation
import Metadata

public class InMemoryIndex<Pointer>: Index where Pointer: UnsignedInteger, Pointer: FixedWidthInteger {

  private let metadata: Metadata
  private let tree:     [Pointer: Node<Pointer>]

  init(metadata: Metadata, tree: [Pointer: Node<Pointer>]) {
    self.metadata = metadata
    self.tree = tree
  }

  required public convenience init(metadata: Metadata, stream createStream: @autoclosure () -> InputStream) {
    precondition(
      metadata.recordSize < (MemoryLayout<Pointer>.size * 8),
      """
      The byte size of a record described by the metadata won't fit the memory layout of type \(Pointer.self).
      : Metadata Record Size : \(metadata.recordSize) bits
      : Memory Layout Size of \(Pointer.self) : \(MemoryLayout<Pointer>.size) bytes.\n
      """
    )
    let stream = createStream()
    precondition(stream.streamStatus == Stream.Status.notOpen, "should have provided an untouched stream.")
    let searchTreeSize = Int(metadata.searchTreeSize)
    stream.open()
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: searchTreeSize)
    let read   = stream.read(buffer, maxLength: searchTreeSize)

    var tree: [Pointer: Node<Pointer>] = [:]
    let nodes = Data(
      bytesNoCopy: buffer,
      count: read,
      deallocator: .none
    )
      .chunked(into: Int(metadata.nodeByteSize))
      .map({ Node<Pointer>($0) })
    for (pointer, node) in nodes.enumerated() { tree[Pointer(pointer)] = node }

    buffer.deallocate()
    stream.close()
    precondition(tree.count == metadata.nodeCount)
    self.init(metadata: metadata, tree: tree)
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

    while pointer < metadata.nodeCount {
      guard let direction = stack.popLast() else { break }
      guard let node = tree[pointer] else { return pointer }

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
