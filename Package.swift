// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "GeoIP2",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "GeoIP2",
      targets: ["GeoIP2"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "GeoIP2",
      dependencies: [
        .target(name: "libmaxminddb_helper"),
        .target(name: "libmaxminddb")
      ],
      path: "Sources/Swift"
    ),

    .target(
      name: "libmaxminddb_helper",
      dependencies: ["libmaxminddb"],
      path: "Sources/libmaxminddb_helper",
      sources: ["./src/"],
      publicHeadersPath: "./include/"
    ),

    .target(
      name: "libmaxminddb_config",
      dependencies: [],
      path: "Sources/libmaxminddb_config",
      sources: ["./src/"],
      publicHeadersPath: "./include/"
    ),

    .target(
      name: "libmaxminddb",
      dependencies: ["libmaxminddb_config"],
      path: "Sources/libmaxminddb",
      exclude: [
        "./autom4te.cache/",
        "./bin/",
        "./dev-bin/",
        "./doc/",
        "./man/",
        "./projects/",
        "./t/"
      ],
      sources: ["./src/"],
      publicHeadersPath: "./include/",
      cSettings: [CSetting.define("PACKAGE_VERSION", to: "\"1.3.2\"")]
    ),

    .testTarget(
      name: "GeoIP2Tests",
      dependencies: ["GeoIP2"]
    ),
  ]
)
