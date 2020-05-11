import Foundation
import MaxMindDecoder
import Index

public class InMemoryReader {

  static let dataSectionSeparator      = Data(count: 16)
  static let metadataStartMarker: Data = Data([0xAB, 0xCD, 0xEF]) +
                                         Data("MaxMind.com".utf8)

  private let databaseContent: Data
  private let indexRange:      Range<Data.Index>
  let metadata: Metadata

  public init(data: Data) throws {
    databaseContent = data
    guard let metaIndex = databaseContent.lastIndex(of: InMemoryReader.metadataStartMarker) else {
      throw ReaderError.missingMetadata
    }
    guard let metaStartIndex = databaseContent.index(
      metaIndex,
      offsetBy: InMemoryReader.metadataStartMarker.count,
      limitedBy: databaseContent.endIndex
    ) else {
      throw ReaderError.corruptMetadata
    }

    let metadataRange = Range(uncheckedBounds: (
      lower: metaStartIndex,
      upper: databaseContent.endIndex
    ))
    let rawMetadata   = databaseContent.subdata(in: metadataRange)
    guard let metadata = MetadataStruct(rawMetadata) else {
      throw ReaderError.corruptMetadata
    }

    self.metadata = metadata
    self.indexRange = Range(uncheckedBounds: (
      lower: databaseContent.startIndex,
      upper: databaseContent.index(of: InMemoryReader.dataSectionSeparator)!
    ))
  }

  public convenience init(fileAtPath: String) throws {
    guard let inputStream = InputStream(fileAtPath: fileAtPath) else {
      throw ReaderError.cantCreateInputStream(filePath: fileAtPath)
    }
    try self.init(data: Data(inputStream: inputStream))
  }

  func get(_ ip: IpAddress) {
    if case .v6 = ip {
      precondition(
        metadata.ipVersion != 4,
        "MaxMind Database \(metadata.databaseType) is of IPV4, while attempt to lookup an IPV6 was made."
      )
    }
    print("metadata.recordSize   : \(metadata.recordSize) bits")
    print("metadata.nodeCount    : \(metadata.nodeCount) nodes")
    print("metadata.nodeByteSize : \(metadata.nodeByteSize) bytes")
    print("ip                    : \(ip)")
    print("================================================")
    let range        = Range(uncheckedBounds: (
      lower: databaseContent.startIndex,
      upper: databaseContent.index(
        databaseContent.startIndex,
        offsetBy: Int(metadata.nodeByteSize) * 2,
        limitedBy: databaseContent.endIndex
      ) ?? databaseContent.endIndex
    ))
    let subdata      = databaseContent.subdata(in: range)
    var count        = 1
    var binaryResult = ""
    var left         = Data(capacity: Int(metadata.nodeByteSize) / 2)
    var right        = Data(capacity: Int(metadata.nodeByteSize) / 2)

    for byte in subdata {
      let binary = String(byte, radix: 2)
      binaryResult += String(repeating: "0", count: 8 - binary.count) + binary
      if (count == metadata.nodeByteSize) {
        binaryResult += "\n————————————————————————————————————\n"
      } else {
        binaryResult += count % 4 == 0 ? "\n" : " "
      }
      if count <= metadata.nodeByteSize / 2 {
        left.append(byte)
      } else if count <= metadata.nodeByteSize {
        right.append(byte)
      }
      count += 1
    }
    print(binaryResult)
    print("================================================")
    let decoder = MaxMindDecoder(inputEndianness: .big)
    print(" Left Byte  : \(decoder.decode(left) as UInt32)")
    print(" Right Byte : \(decoder.decode(right) as UInt32)")
  }

}
