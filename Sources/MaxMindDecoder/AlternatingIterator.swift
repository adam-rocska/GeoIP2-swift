import Foundation

protocol AlternatingIterator {

  var isExhausted: Bool { get }

  func rewind()

  func seek(to: Int)

  func next() -> ControlByte?

  func next(_ controlByte: ControlByte) -> Data

}
