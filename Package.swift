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
    .target(name: "Index", dependencies: ["Decoder", "Metadata"]),
    .target(name: "DataSection", dependencies: ["Decoder", "Metadata"]),
    .target(name: "Metadata", dependencies: ["Decoder"]),
    .target(name: "Decoder", dependencies: [], path: "Sources/Decoder"),
    .target(name: "DBReader", dependencies: ["Index", "DataSection", "Metadata", "Decoder"]),
    .target(name: "Api", dependencies: ["DBReader"]),

    .testTarget(name: "IndexTests", dependencies: ["Index", "Metadata"]),
    .testTarget(name: "DataSectionTests", dependencies: ["DataSection", "Metadata"]),
    .testTarget(name: "MetadataTests", dependencies: ["Metadata", "Decoder"]),
    .testTarget(name: "DecoderTests", dependencies: ["Decoder"]),
    .testTarget(name: "DBReaderTests", dependencies: ["DBReader"]),
    .testTarget(name: "ApiTests", dependencies: ["Api"])
  ]
)
