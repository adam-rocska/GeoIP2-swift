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

  func testLastIndex_ofData() {
    XCTAssertEqual(6, "Hello World".asciiData.lastIndex(of: "World".asciiData))
    XCTAssertEqual(18, "Hello World Hello World".asciiData.lastIndex(of: "World".asciiData))
    XCTAssertNil("Hello world".asciiData.lastIndex(of: "World".asciiData))
    XCTAssertNil("Hello world Hello world".asciiData.lastIndex(of: "World".asciiData))
    XCTAssertEqual(17, "Hello world SOME World".asciiData.lastIndex(of: "World".asciiData))
    XCTAssertNil("hello world".asciiData.lastIndex(of: "Hello".asciiData))
    XCTAssertNil("hello World SOME World".asciiData.lastIndex(of: "Hello".asciiData))
    XCTAssertNil("hello world SOME World".asciiData.lastIndex(of: "Hello".asciiData))
    XCTAssertEqual(30, "Hello World Hello World Hello World".asciiData.lastIndex(of: "World".asciiData))
  }

  func testLastIndex_ofData_fromIndex() {
    XCTAssertEqual(6, "Hello World".asciiData.lastIndex(of: "World".asciiData, from: 3))
    XCTAssertNil("Hello world".asciiData.lastIndex(of: "World".asciiData, from: 3))
    XCTAssertEqual(17, "Hello World SOME World".asciiData.lastIndex(of: "World".asciiData, from: 6))
    XCTAssertNil("Hello World".asciiData.lastIndex(of: "Hello".asciiData, from: 3))
    XCTAssertNil("hello World".asciiData.lastIndex(of: "hello".asciiData, from: 3))
    XCTAssertNil("hello world".asciiData.lastIndex(of: "Hello".asciiData, from: 3))
    XCTAssertNil("hello World SOME World".asciiData.lastIndex(of: "Hello".asciiData, from: 3))
    XCTAssertNil("hello world SOME World".asciiData.lastIndex(of: "Hello".asciiData, from: 3))
    XCTAssertEqual(18, "Hello World Hello World".asciiData.lastIndex(of: "World".asciiData, from: 7))

    XCTAssertEqual(18, "Hello World Hello World".asciiData.lastIndex(of: "World".asciiData, from: 10))
    XCTAssertNil("Hello world".asciiData.lastIndex(of: "World".asciiData, from: 2))
    XCTAssertNil("Hello world Hello world".asciiData.lastIndex(of: "World".asciiData, from: 5))
    XCTAssertEqual(40, "Hello world SOME World Hello world SOME World".asciiData.lastIndex(of: "World".asciiData, from: 21))
    XCTAssertNil("hello world".asciiData.lastIndex(of: "Hello".asciiData, from: 10))
    XCTAssertNil("hello World SOME World".asciiData.lastIndex(of: "Hello".asciiData, from: 10))
    XCTAssertNil("hello world SOME World".asciiData.lastIndex(of: "Hello".asciiData, from: 15))
    XCTAssertEqual(30, "Hello World Hello World Hello World".asciiData.lastIndex(of: "World".asciiData, from: 18))
  }
}
