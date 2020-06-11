// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "GeoIP2",
  products: [
    .library(name: "GeoIP2", targets: ["Api"])
  ],
  dependencies: [],
  targets: [
    // MARK : Sources
    .target(name: "IndexReader", dependencies: ["Decoder", "MetadataReader"]),
    .target(name: "DataSection", dependencies: ["Decoder", "MetadataReader"]),
    .target(name: "MetadataReader", dependencies: ["Decoder"]),
    .target(name: "Decoder", dependencies: [], path: "Sources/Decoder"),
    .target(name: "DBReader", dependencies: ["IndexReader", "DataSection", "MetadataReader", "Decoder"]),
    .target(name: "Api", dependencies: ["DBReader", "Decoder", "MetadataReader", "IndexReader"]),

    // MARK : Temporary hackery until CLion supports new Swift Package Manager with its Resources handling.
    .target(name: "TestResources", dependencies: [], path: "Tests/TestResources"),
    // MARK : "unit" tests. They will be actual unit tests one day.
    .testTarget(
      name: "IndexReaderTests",
      dependencies: ["TestResources", "IndexReader", "MetadataReader"],
      path: "Tests/Unit/IndexReaderTests"
    ),
    .testTarget(
      name: "DataSectionTests",
      dependencies: ["TestResources", "DataSection", "MetadataReader"],
      path: "Tests/Unit/DataSectionTests"
    ),
    .testTarget(
      name: "MetadataReaderTests",
      dependencies: ["TestResources", "MetadataReader", "Decoder"],
      path: "Tests/Unit/MetadataReaderTests"
    ),
    .testTarget(
      name: "DecoderTests",
      dependencies: ["TestResources", "Decoder"],
      path: "Tests/Unit/DecoderTests"
    ),
    .testTarget(
      name: "DBReaderTests",
      dependencies: ["TestResources", "DBReader"],
      path: "Tests/Unit/DBReaderTests"
    ),
    .testTarget(
      name: "ApiTests",
      dependencies: ["TestResources", "Api", "Decoder", "IndexReader", "DBReader", "MetadataReader"],
      path: "Tests/Unit/ApiTests"
    ),

    // MARK : System tests
    .testTarget(
      name: "GeoIP2_FileBased",
      dependencies: ["TestResources", "Api"],
      path: "Tests/System/FileBased"
    ),

    // MARK : Performance tests
    .testTarget(
      name: "GeoIP2_PerformanceTests",
      dependencies: ["TestResources", "Api"],
      path: "Tests/Performance"
    )
  ]
)
