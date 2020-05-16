import Foundation

public extension MaxMindDecoder {

  private func resolveKey(_ iterator: MaxMindIterator) -> String? {
    switch iterator.next() {
      case .some(let cb) where cb.type == .pointer:
        let resolver = MaxMindPointerResolver(dataSequence: iterator, decoder: self)




//        print(resolver.resolve(MaxMindPointer(1)))
        print(resolver.resolve(MaxMindPointer(719)))
//        print(resolver.resolve(MaxMindPointer(12)))
//        print(resolver.resolve(MaxMindPointer(122)))
//        print(resolver.resolve(MaxMindPointer(20)))
//        print(resolver.resolve(MaxMindPointer(2144)))
//        print(resolver.resolve(MaxMindPointer(35)))




        let pointer  = decode(iterator.next(cb), strayBits: cb.strayBits)
        print(pointer)
        guard let resolvedValue = resolver.resolve(pointer) else { return nil }
        if resolvedValue.controlByte.type == .utf8String {
          return resolvedValue.value as! String
        }
        return nil
      case .some(let cb) where cb.type == .utf8String:
        return decode(iterator.next(cb))
      default:
        return nil
    }
  }

  func decode(_ iterator: MaxMindIterator, size: Int) -> [String: Any] {
    var result: [String: Any] = [:]
    for _ in 0..<size {
      guard let key: String = resolveKey(iterator) else { break }

      guard let valueControlByte = iterator.next() else { break }
      switch valueControlByte.type {
        case .pointer:
          if valueControlByte.payloadSize == 0 {print("büdös szakmunkás parasztok")}
          let resolver = MaxMindPointerResolver(dataSequence: iterator, decoder: self)
          let valueBinary = iterator.next(valueControlByte)
          let mindPointer = decode(valueBinary, strayBits: valueControlByte.strayBits)
          print(mindPointer)
          result[key] = resolver.resolve(mindPointer)?.value
        case .map, .array:
          result[key] = decode(iterator, as: valueControlByte)
        default:
          let valueBinary = iterator.next(valueControlByte)
          result[key] = decode(valueBinary, as: valueControlByte)
      }
    }
    return result
  }

  func decode(_ data: Data, size: Int) -> [String: Any] {
    guard let iterator = MaxMindIterator(data) else { return [:] }
    return decode(iterator, size: size)
  }
}
