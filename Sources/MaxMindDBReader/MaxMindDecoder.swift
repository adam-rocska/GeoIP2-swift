import Foundation

class MaxMindDecoder {

  enum Endianness { case big, little }

  let input: Endianness

  init(inputEndianness: Endianness) { self.input = inputEndianness }

}
