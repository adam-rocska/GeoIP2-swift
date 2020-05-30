// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "GeoIP2",
  products: [
    .library(
      name: "GeoIP2",
      targets: ["Api"]
    ),
    .library(
      name: "DBReader",
      targets: ["DBReader"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(name: "Index", dependencies: ["Decoder", "MetadataReader"]),
    .target(name: "DataSection", dependencies: ["Decoder", "MetadataReader"]),
    .target(name: "MetadataReader", dependencies: ["Decoder"]),
    .target(name: "Decoder", dependencies: [], path: "Sources/Decoder"),
    .target(name: "DBReader", dependencies: ["Index", "DataSection", "MetadataReader", "Decoder"]),
    .target(name: "Api", dependencies: ["DBReader", "Decoder", "MetadataReader", "Index"]),

    .testTarget(name: "IndexTests", dependencies: ["Index", "MetadataReader"]),
    .testTarget(name: "DataSectionTests", dependencies: ["DataSection", "MetadataReader"]),
    .testTarget(name: "MetadataReaderTests", dependencies: ["MetadataReader", "Decoder"]),
    .testTarget(name: "DecoderTests", dependencies: ["Decoder"]),
    .testTarget(name: "DBReaderTests", dependencies: ["DBReader"]),
    .testTarget(name: "ApiTests", dependencies: ["Api", "Decoder", "Index","DBReader", "MetadataReader"])
  ]
)
