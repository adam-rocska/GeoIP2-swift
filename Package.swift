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
      name: "MaxMindDBReader",
      dependencies: [],
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
    )
  ]
)
