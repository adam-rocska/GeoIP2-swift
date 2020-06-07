import Foundation

public typealias IpV4Tuple = (UInt8, UInt8, UInt8, UInt8)
public typealias IpV6Tuple = (
  UInt8, UInt8, UInt8, UInt8,
  UInt8, UInt8, UInt8, UInt8,
  UInt8, UInt8, UInt8, UInt8,
  UInt8, UInt8, UInt8, UInt8
)

public enum IpAddress: Equatable, CustomStringConvertible {
  public var description: String {
    switch self {
      case .v4: return self.data.map({ String($0, radix: 10) }).joined(separator: ".")
      case .v6:
        let bytes: [String] = self.data
          .map({ String($0, radix: 16) })
          .map({ String(repeating: "0", count: 2 - $0.count) + $0 })

        var result     = ""
        var bytesAdded = 0
        for byte in bytes {
          result += byte
          bytesAdded += 1
          if bytesAdded % 2 == 0 && bytesAdded != 16 { result += ":" }
        }
        return result
    }
  }

  // utility property to help IP Address to metadata matching, because of the php scripter style design of the db & its metadata
  internal var version: UInt16 {
    switch self {
      case .v4: return 4
      case .v6: return 6
    }
  }

  case v4(UInt8, UInt8, UInt8, UInt8)
  case v6(
    UInt8, UInt8, UInt8, UInt8,
    UInt8, UInt8, UInt8, UInt8,
    UInt8, UInt8, UInt8, UInt8,
    UInt8, UInt8, UInt8, UInt8
  )

  public var data: Data {
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

  public static func v4(_ data: Data) -> IpAddress {
    precondition(data.count == 4, "IPv4 strings must have 4, and only 4 bytes defined.")
    return v4(data[0], data[1], data[2], data[3])
  }

  public static func v4(_ string: String) -> IpAddress {
    let rawChunks = string.split(separator: ".").compactMap({ Int($0) })
    precondition(rawChunks.count == 4, "IPv4 strings must have 4, and only 4 bytes defined.")
    precondition(rawChunks.allSatisfy({ $0 >= 0 && $0 < 256 }), "All IPv4 bytes must be valid unsigned 8 bit values.")
    let bytes = rawChunks.map({ UInt8($0) })
    return v4(bytes[0], bytes[1], bytes[2], bytes[3])
  }

  public static func v6(_ ip: IpAddress) -> IpAddress {
    switch ip {
      case .v6: return ip
      case let .v4(bytes): return v6(
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0xFF, 0xFF,
        bytes.0, bytes.1, bytes.2, bytes.3
      )
    }
  }

  public static func v6(_ string: String) -> IpAddress {
    let inputRawChunks = string.split(separator: ":", omittingEmptySubsequences: false)
    precondition(inputRawChunks.count <= 8, "IPv6 strings must have at most 8 bytes defined.")
    var prefixBytes: [UInt8] = []
    var suffixBytes: [UInt8] = []
    var emptyChunksFound     = 0
    for chunk in inputRawChunks {
      if chunk.count > 4 {
        precondition(chunk.filter({ $0 == "." }).count == 3, "Invalid hexadectet \"\(chunk)\" provided in \(string) .")
        let ipv4 = v4(String(chunk)).data
        if emptyChunksFound == 0 {
          prefixBytes.append(ipv4[0])
          prefixBytes.append(ipv4[1])
          prefixBytes.append(ipv4[2])
          prefixBytes.append(ipv4[3])
        } else {
          suffixBytes.append(ipv4[0])
          suffixBytes.append(ipv4[1])
          suffixBytes.append(ipv4[2])
          suffixBytes.append(ipv4[3])
        }
        continue
      }
      if chunk.isEmpty {
        precondition(emptyChunksFound <= 2, "Invalid IPv6 format provided : \(string)")
        emptyChunksFound += 1
        continue
      }
      let hexadectet      = String(repeating: "0", count: 4 - chunk.count) + chunk
      let separationIndex = hexadectet.index(hexadectet.startIndex, offsetBy: 2)

      let byte1 = UInt8(hexadectet[..<separationIndex], radix: 16)
      precondition(byte1 != nil, "Invalid hexadectet \"\(hexadectet)\" in ip : \(string)")
      let byte2 = UInt8(hexadectet[separationIndex...], radix: 16)
      precondition(byte2 != nil, "Invalid hexadectet \"\(hexadectet)\" in ip : \(string)")


      if emptyChunksFound == 0 {
        prefixBytes.append(byte1!)
        prefixBytes.append(byte2!)
      } else {
        suffixBytes.append(byte1!)
        suffixBytes.append(byte2!)
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

  public static func v6(_ data: Data) -> IpAddress {
    precondition(data.count == 16, "An IPv6 address can only be created of 16 byte sized binary Data.")
    return v6(
      data[0], data[1], data[2], data[3],
      data[4], data[5], data[6], data[7],
      data[8], data[9], data[10], data[11],
      data[12], data[13], data[14], data[15]
    )
  }

}

public extension IpAddress {
  init(_ string: String) {
    if string.contains(":") {
      self = IpAddress.v6(string)
    } else if string.contains(".") {
      self = IpAddress.v4(string)
    } else {
      preconditionFailure("Unrecognized IP Address specification.")
    }
  }

  init(_ data: Data) {
    switch data.count {
      case 4: self = IpAddress.v4(data)
      case 16: self = IpAddress.v6(data)
      default: preconditionFailure("Unrecognized IP Address binary.")
    }
  }
}

public func ==(lhs: IpV6Tuple, rhs: IpV6Tuple) -> Bool {
  return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2 && lhs.3 == rhs.3 &&
         lhs.4 == rhs.4 && lhs.5 == rhs.5 && lhs.6 == rhs.6 && lhs.7 == rhs.7 &&
         lhs.8 == rhs.8 && lhs.9 == rhs.9 && lhs.10 == rhs.10 && lhs.11 == rhs.11 &&
         lhs.12 == rhs.12 && lhs.13 == rhs.13 && lhs.14 == rhs.14 && lhs.15 == rhs.15
}

public func ==(lhs: IpAddress, rhs: IpAddress) -> Bool {
  switch (lhs, rhs) {
    case let (.v6(a), .v6(b)): return a == b
    case let (.v4(a), .v4(b)): return a == b
    case (.v4, .v6): return IpAddress.v6(lhs) == rhs
    case (.v6, .v4): return IpAddress.v6(rhs) == lhs
  }
}

extension IpAddress: Comparable {
  public static func <(lhs: IpAddress, rhs: IpAddress) -> Bool {
    let left:  Data
    let right: Data
    switch (lhs, rhs) {
      case (.v4, .v6):
        left = IpAddress.v6(lhs).data
        right = rhs.data
      case (.v6, .v4):
        left = lhs.data
        right = IpAddress.v6(rhs).data
      default:
        left = lhs.data
        right = rhs.data
    }
    var rightSideIndex = right.startIndex
    for leftByte in left {
      defer { rightSideIndex = right.index(after: rightSideIndex) }
      let rightByte = right[rightSideIndex]
      if leftByte < rightByte { return true }
    }
    return false
  }
}