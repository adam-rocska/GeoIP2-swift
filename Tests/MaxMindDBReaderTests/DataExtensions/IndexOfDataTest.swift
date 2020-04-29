import Foundation
import XCTest
@testable import MaxMindDBReader

fileprivate extension String {
  var asciiData: Data { get { return self.data(using: .ascii) ?? Data() } }
}

class IndexOfDataTest: XCTestCase {
  func testIndex_ofData() {
    XCTAssertEqual(6, "Hello World".asciiData.index(of: "World".asciiData))
    XCTAssertNil("Hello world".asciiData.index(of: "World".asciiData))
    XCTAssertEqual(6, "Hello World SOME World".asciiData.index(of: "World".asciiData))
    XCTAssertEqual(17, "Hello world SOME World".asciiData.index(of: "World".asciiData))
    XCTAssertEqual(0, "Hello World".asciiData.index(of: "Hello".asciiData))
    XCTAssertEqual(0, "hello World".asciiData.index(of: "hello".asciiData))
    XCTAssertNil("hello world".asciiData.index(of: "Hello".asciiData))
    XCTAssertNil("hello World SOME World".asciiData.index(of: "Hello".asciiData))
    XCTAssertNil("hello world SOME World".asciiData.index(of: "Hello".asciiData))
  }

  func testIndex_ofData_fromIndex() {
    XCTAssertEqual(6, "Hello World".asciiData.index(of: "World".asciiData, from: 3))
    XCTAssertNil("Hello world".asciiData.index(of: "World".asciiData, from: 3))
    XCTAssertEqual(6, "Hello World SOME World".asciiData.index(of: "World".asciiData, from: 2))
    XCTAssertEqual(17, "Hello world SOME World".asciiData.index(of: "World".asciiData, from: 4))
    XCTAssertNil("Hello World".asciiData.index(of: "Hello".asciiData, from: 3))
    XCTAssertNil("hello World".asciiData.index(of: "hello".asciiData, from: 3))
    XCTAssertNil("hello world".asciiData.index(of: "Hello".asciiData, from: 3))
    XCTAssertNil("hello World SOME World".asciiData.index(of: "Hello".asciiData, from: 3))
    XCTAssertNil("hello world SOME World".asciiData.index(of: "Hello".asciiData, from: 3))
    XCTAssertEqual(6, "Hello World Hello World".asciiData.index(of: "World".asciiData, from: 6))
    XCTAssertEqual(18, "Hello World Hello World".asciiData.index(of: "World".asciiData, from: 7))
  }
}
