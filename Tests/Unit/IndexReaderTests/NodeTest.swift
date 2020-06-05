import Foundation
import XCTest
import TestResources
@testable import IndexReader

class NodeTest: XCTestCase {

  private func assertInitFromData<T>(
    _ left: T,
    _ right: T,
    file: StaticString = #file,
    line: UInt = #line
  ) where T: UnsignedInteger, T: FixedWidthInteger {
    for input in createBinaryInputsFor(left, right) {
      let node = Node<T>(input)
      XCTAssertEqual(
        left,
        node.left,
        "Expected node's left record to be \(left), but was \(node.left) during node size variation of \(input)",
        file: file,
        line: line
      )
      XCTAssertEqual(
        right,
        node.right,
        "Expected node's right record to be \(right), but was \(node.right) during node size variation of \(input)",
        file: file,
        line: line
      )
      XCTAssertEqual(Node(left: left, right: right), node)
    }
  }

  private func createRepresentations<T>(of value: T) -> [Data] where T: UnsignedInteger {
    let valueBinary = CFByteOrderGetCurrent() == CFByteOrderBigEndian.rawValue
                      ? withUnsafeBytes(of: value, { Data($0) })
                      : Data(withUnsafeBytes(of: value, { Data($0) }).reversed())

    let minimalRepresentation: Data
    if valueBinary.allSatisfy({ $0 == 0 }) {
      minimalRepresentation = Data([0b0000_0000])
    } else {
      minimalRepresentation = valueBinary.subdata(in: Range(
        uncheckedBounds: (
          lower: valueBinary.firstIndex(where: { $0 != 0 }) ?? valueBinary.startIndex,
          upper: valueBinary.endIndex
        )
      ))
    }

    let maxSize = MemoryLayout<T>.size
    let minSize = minimalRepresentation.count

    var representations: [Data] = []
    for i in minSize...maxSize {
      representations.append(Data(count: i - minSize) + minimalRepresentation)
    }
    return representations
  }

  private typealias BinaryNode = (left: Data, right: Data, nibbleByte: Data)

  private func equalSizedRepresentations<T>(
    _ left: T,
    _ right: T
  ) -> [BinaryNode] where T: UnsignedInteger, T: FixedWidthInteger {
    let leftRepresentations  = createRepresentations(of: left)
    let rightRepresentations = createRepresentations(of: right)
    let leftCount            = leftRepresentations.count
    let rightCount           = rightRepresentations.count
    let difference           = leftCount - rightCount

    let result: [(left: Data, right: Data, nibbleByte: Data, length: Int)]
    if difference <= 0 {
      result = leftRepresentations.enumerated().map { index, element in
        (
          left: element,
          right: rightRepresentations[index + abs(difference)],
          nibbleByte: Data([]),
          length: element.count + rightRepresentations[index + abs(difference)].count
        )
      }
    } else {
      result = rightRepresentations.enumerated().map { index, element in
        (
          left: leftRepresentations[index + difference],
          right: element,
          nibbleByte: Data([]),
          length: leftRepresentations[index + difference].count + element.count
        )
      }
    }

    let resultWithStubNibbleBytes = result[..<result.index(before: result.endIndex)]
      .map { result in
      (
        left: result.left,
        right: result.right,
        nibbleByte: Data([0b0000_0000]),
        length: result.length + 1
      )
    }

    let representations = (result + resultWithStubNibbleBytes)
      .sorted(by: { $0.length < $1.length })
      .map { left, right, nibbleByte, length in (left: left, right: right, nibbleByte: nibbleByte) }

    if let firstCommonRepresentation = representations.first {
      if canCompressInNibble(firstCommonRepresentation.left, firstCommonRepresentation.right) {
        return [compress(firstCommonRepresentation)] + representations
      }
    }

    return representations
  }

  private func compress(_ node: BinaryNode) -> BinaryNode {
    precondition(canCompressInNibble(node.left, node.right))
    return (
      left: node.left[node.left.index(after: node.left.startIndex)...],
      right: node.right[node.right.index(after: node.right.startIndex)...],
      nibbleByte: Data([node.left.first! << 4 | node.right.first!])
    )
  }

  private func canCompressInNibble(_ left: Data, _ right: Data) -> Bool {
    guard let leftLeadingByte = left.first else { return false }
    guard let rightLeadingByte = right.first else { return false }
    if (rightLeadingByte & 0b0000_1111) != rightLeadingByte { return false }
    if (leftLeadingByte & 0b0000_1111) != leftLeadingByte { return false }
    return true
  }

  func createBinaryInputsFor<T>(
    _ left: T,
    _ right: T
  ) -> [Data] where T: UnsignedInteger, T: FixedWidthInteger {
    return equalSizedRepresentations(left, right).reduce([]) { result, tuple in
      result + [tuple.left + tuple.nibbleByte + tuple.right]
    }
  }

  func testInit_fromData() {
    let valuesToCheck = [
      (10, 15),
      (0, 10),
      (255, 128),
      (65534, 15000),
      (0xFFFFFFF, 0xFFFFFF),
      (0xFFFFFFFF, 0xFFFFFFF),
      (0xFFFFFFFFFFFF, 0xFFFFFFFFFFF),
      (0xFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFF)
    ]

    for (left, right) in valuesToCheck {
      if left <= UInt8.max && right <= UInt8.max {
        assertInitFromData(UInt8(left), UInt8(right))
      }
      if left <= UInt16.max && right <= UInt16.max {
        assertInitFromData(UInt16(left), UInt16(right))
      }
      if left <= UInt32.max && right <= UInt32.max {
        assertInitFromData(UInt32(left), UInt32(right))
      }
      if left <= UInt64.max && right <= UInt64.max {
        assertInitFromData(UInt64(left), UInt64(right))
      }
    }
  }

}
