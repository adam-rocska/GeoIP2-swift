import Foundation
import MaxMindDecoder

struct Node<Record> where Record: UnsignedInteger, Record: FixedWidthInteger {

  let left:  Record
  let right: Record

  init(left: Record, right: Record) {
    self.left = left
    self.right = right
  }

  init(_ data: Data) {
    precondition(!data.isEmpty)
    var leftData:  Data
    var rightData: Data
    let leftRange = Range(uncheckedBounds: (
      lower: data.startIndex,
      upper: data.index(
        data.startIndex,
        offsetBy: data.count / 2,
        limitedBy: data.endIndex
      )!
    ))

    if data.count % 2 == 0 {
      let rightRange = Range(uncheckedBounds: (
        lower: leftRange.upperBound,
        upper: data.endIndex
      ))
      leftData = data.subdata(in: leftRange)
      rightData = data.subdata(in: rightRange)
    } else {
      let rightRange = Range(uncheckedBounds: (
        lower: leftRange.upperBound + 1,
        upper: data.endIndex
      ))

      let leftNibble  = Data([data[leftRange.upperBound] &>> 4])
      let rightNibble = Data([data[leftRange.upperBound] & 0b0000_1111])
      leftData = leftNibble + data.subdata(in: leftRange)
      rightData = rightNibble + data.subdata(in: rightRange)
    }

    let decoder = MaxMindDecoder(inputEndianness: .big)
    self.left = decoder.decode(leftData) as Record
    self.right = decoder.decode(rightData) as Record
  }
}
