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
      name: "MaxMindDecoder",
      dependencies: [],
      path: "Sources/MaxMindDecoder"
    ),
    .target(
      name: "Index",
      dependencies: ["MaxMindDecoder"],
      path: "Sources/Index"
    ),
    .target(
      name: "Metadata",
      dependencies: ["MaxMindDecoder"],
      path: "Sources/Metadata"
    ),

    .target(
      name: "MaxMindDBReader",
      dependencies: ["Index", "Metadata", "MaxMindDecoder"],
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
      dependencies: ["Index"]
    ),

    .testTarget(
      name: "MetadataTests",
      dependencies: ["Metadata"]
    ),

    .testTarget(
      name: "MaxMindDecoderTests",
      dependencies: ["MaxMindDecoder"]
    )
  ]
)
