import Foundation
import Metadata

public class InMemoryIndex<Pointer>: Index where Pointer: UnsignedInteger, Pointer: FixedWidthInteger {

  private let metadata: Metadata
  private let tree:     [Node<Pointer>]

  init(metadata: Metadata, tree: [Node<Pointer>]) {
    self.metadata = metadata
    self.tree = tree
  }

  required public convenience init(metadata: Metadata, stream createStream: @autoclosure () -> InputStream) {
    let stream = createStream()
    precondition(stream.streamStatus == Stream.Status.notOpen, "should have provided an untouched stream.")
    let searchTreeSize = Int(metadata.searchTreeSize)
    stream.open()
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: searchTreeSize)
    let read   = stream.read(buffer, maxLength: searchTreeSize)
    let tree: [Node<Pointer>] = Data(
      bytesNoCopy: buffer,
      count: read,
      deallocator: .unmap
    )
      .chunked(into: Int(metadata.nodeByteSize))
      .map({ Node($0) })
    buffer.deallocate()
    stream.close()
    precondition(tree.count == metadata.nodeCount)
    self.init(metadata: metadata, tree: tree)
  }

  public func lookup(_ ip: IpAddress) -> Pointer? {
    var stack = LookupDirection.createLookupStack(of: ip.data)
    return nil
  }

}
