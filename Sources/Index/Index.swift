import Foundation

public class Index {
  private let tree: Tree

  init(recordSize: UInt16, nodeCount: UInt32, nodeByteSize: UInt16, data: Data) {
    self.tree = Tree(
      recordSize: recordSize,
      nodeCount: nodeCount,
      nodeByteSize: nodeByteSize,
      data: data
    )
  }

}
