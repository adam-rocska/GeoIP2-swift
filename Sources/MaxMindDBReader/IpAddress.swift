import Foundation

typealias IpV4Tuple = (UInt8, UInt8, UInt8, UInt8)
typealias IpV6Tuple = (
  UInt8, UInt8, UInt8, UInt8,
  UInt8, UInt8, UInt8, UInt8,
  UInt8, UInt8, UInt8, UInt8,
  UInt8, UInt8, UInt8, UInt8
)

public enum IpAddress: Equatable {
  case v4(UInt8, UInt8, UInt8, UInt8)
  case v6(
    UInt8, UInt8, UInt8, UInt8,
    UInt8, UInt8, UInt8, UInt8,
    UInt8, UInt8, UInt8, UInt8,
    UInt8, UInt8, UInt8, UInt8
  )

  var data: Data {
    get {
      switch self {
        case let (.v4(a)): return Data([a.0, a.1, a.2, a.3])
        case let (.v6(a)): return Data([
                                         a.0, a.1, a.2, a.3,
                                         a.4, a.5, a.6, a.7,
                                         a.8, a.9, a.10, a.11,
                                         a.12, a.13, a.14, a.15,
                                       ])
      }
    }
  }

  static func v4(_ data: Data) -> IpAddress {
    precondition(data.count == 4, "IPv4 strings must have 4, and only 4 bytes defined.")
    return v4(data[0], data[1], data[2], data[3])
  }

  static func v4(_ string: String) -> IpAddress {
    let rawChunks = string.split(separator: ".").compactMap({ Int($0) })
    precondition(rawChunks.count == 4, "IPv4 strings must have 4, and only 4 bytes defined.")
    precondition(rawChunks.allSatisfy({ $0 > 0 && $0 < 256 }), "All IPv4 bytes must be valid unsigned 8 bit values.")
    let bytes = rawChunks.map({ UInt8($0) })
    return v4(bytes[0], bytes[1], bytes[2], bytes[3])
  }

  static func v6(_ string: String) -> IpAddress {
    let inputRawChunks = string.split(separator: ":")
    precondition(inputRawChunks.count <= 8, "IPv6 strings must have at most 8 bytes defined.")
    var prefixBytes: [UInt8] = []
    var suffixBytes: [UInt8] = []
    var shouldProcessPrefix  = true
    for chunk in inputRawChunks {
      if chunk.isEmpty {
        if !shouldProcessPrefix {
          preconditionFailure("Invalid IPv6 format provided.")
        }
        shouldProcessPrefix = false
        continue
      }
      let hexadectet      = String(repeating: "0", count: 4 - chunk.count) + chunk
      let separationIndex = hexadectet.index(hexadectet.startIndex, offsetBy: 2)

      guard let byte1 = UInt8(hexadectet[..<separationIndex], radix: 16) else {
        preconditionFailure("Invalid hexadectet defined: \(hexadectet)")
      }
      guard let byte2 = UInt8(hexadectet[..<separationIndex], radix: 16) else {
        preconditionFailure("Invalid hexadectet defined: \(hexadectet)")
      }

      if shouldProcessPrefix {
        prefixBytes.append(byte1)
        prefixBytes.append(byte2)
      } else {
        suffixBytes.append(byte1)
        suffixBytes.append(byte2)
      }
    }

    let fillBytes = [UInt8](
      repeating: 0,
      count: 16 - (prefixBytes.count + suffixBytes.count)
    )

    let bytes = prefixBytes + fillBytes + suffixBytes
    return v6(
      bytes[0], bytes[1], bytes[2], bytes[3],
      bytes[4], bytes[5], bytes[6], bytes[7],
      bytes[8], bytes[9], bytes[10], bytes[11],
      bytes[12], bytes[13], bytes[14], bytes[15]
    )
  }

  static func v6(_ data: Data) -> IpAddress {
    precondition(data.count == 16, "An IPv6 address can only be created of 16 byte sized binary Data.")
    return v6(
      data[0], data[1], data[2], data[3],
      data[4], data[5], data[6], data[7],
      data[8], data[9], data[10], data[11],
      data[12], data[13], data[14], data[15]
    )
  }

}

func ==(lhs: IpV6Tuple, rhs: IpV6Tuple) -> Bool {
  return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2 && lhs.3 == rhs.3 &&
         lhs.4 == rhs.4 && lhs.5 == rhs.5 && lhs.6 == rhs.6 && lhs.7 == rhs.7 &&
         lhs.8 == rhs.8 && lhs.9 == rhs.9 && lhs.10 == rhs.1 && lhs.11 == rhs.11 &&
         lhs.12 == rhs.12 && lhs.13 == rhs.13 && lhs.14 == rhs.1 && lhs.15 == rhs.15
}

public func ==(lhs: IpAddress, rhs: IpAddress) -> Bool {
  switch (lhs, rhs) {
    case let (.v6(a), .v6(b)): return a == b
    case let (.v4(a), .v4(b)): return a == b
    default: return false
  }
}
