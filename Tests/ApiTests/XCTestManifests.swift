import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GeoIP2_swiftTests.allTests),
    ]
}
#endif
