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
      name: "MaxMindDBReader",
      targets: ["MaxMindDBReader"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Index",
      dependencies: ["Decoder", "Metadata"],
      path: "Sources/Index"
    ),
    .target(
      name: "Metadata",
      dependencies: ["Decoder"]
    ),
    .target(
      name: "Decoder",
      dependencies: [],
      path: "Sources/Decoder"
    ),
    .target(
      name: "DataSection",
      dependencies: ["Decoder", "Metadata"],
      path: "Sources/DataSection"
    ),

    .target(
      name: "MaxMindDBReader",
      dependencies: ["Index", "Metadata", "Decoder"],
      path: "Sources/MaxMindDBReader"
    ),
    .target(
      name: "Api",
      dependencies: ["MaxMindDBReader"],
      path: "Sources/Api"
    ),

    .testTarget(
      name: "ApiTests",
      dependencies: ["Api"]
    ),

    .testTarget(
      name: "MaxMindDBReaderTests",
      dependencies: ["MaxMindDBReader"]
    ),

    .testTarget(
      name: "IndexTests",
      dependencies: ["Index", "Metadata"]
    ),

    .testTarget(
      name: "MetadataTests",
      dependencies: ["Metadata", "Decoder"]
    ),

    .testTarget(
      name: "DecoderTests",
      dependencies: ["Decoder"]
    ),

    .testTarget(
      name: "DataSectionTests",
      dependencies: ["DataSection", "Metadata"]
    )
  ]
)
