import Foundation

class Decoder {

  public enum Endianness { case big, little }

  let input: Endianness

  public init(inputEndianness: Endianness) { self.input = inputEndianness }

}
