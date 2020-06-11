#!/bin/sh

set -e

/Library/Developer/Toolchains/swift-5.0.3-RELEASE.xctoolchain/usr/bin/swift test \
--enable-code-coverage \
--parallel \
--num-workers 4

reset

llvm-cov report \
.build/x86_64-apple-macosx/debug/GeoIP2PackageTests.xctest/Contents/MacOS/GeoIP2PackageTests \
-instr-profile=.build/x86_64-apple-macosx/debug/codecov/default.profdata \
-ignore-filename-regex=".build|Tests" \
-use-color