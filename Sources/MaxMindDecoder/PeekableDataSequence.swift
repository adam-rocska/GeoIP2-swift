import Foundation

public protocol PeekableDataSequence {

  func peek(at offset: Int) -> ControlByte?

  func peek(_ controlByte: ControlByte, at offset: Int) -> Data?

}
