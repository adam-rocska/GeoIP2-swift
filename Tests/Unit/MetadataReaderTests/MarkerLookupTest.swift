import Foundation
import XCTest
@testable import MetadataReader

class MarkerLookupTest: XCTestCase {

  func testFirstOccurrenceIn() {
    let lookupWorld      = MarkerLookup(marker: "World".asciiData)
    let lookupHello      = MarkerLookup(marker: "Hello".asciiData)
    let lookupSmallHello = MarkerLookup(marker: "hello".asciiData)

    XCTAssertEqual(6, lookupWorld.firstOccurrenceIn("Hello World".asciiData))
    XCTAssertNil(lookupWorld.firstOccurrenceIn("Hello world".asciiData))
    XCTAssertEqual(6, lookupWorld.firstOccurrenceIn("Hello World SOME World".asciiData))
    XCTAssertEqual(17, lookupWorld.firstOccurrenceIn("Hello world SOME World".asciiData))
    XCTAssertEqual(0, lookupHello.firstOccurrenceIn("Hello World".asciiData))
    XCTAssertEqual(0, lookupSmallHello.firstOccurrenceIn("hello World".asciiData))
    XCTAssertNil(lookupHello.firstOccurrenceIn("hello world".asciiData))
    XCTAssertNil(lookupHello.firstOccurrenceIn("hello World SOME World".asciiData))
    XCTAssertNil(lookupHello.firstOccurrenceIn("hello world SOME World".asciiData))
  }

  func testIndex_ofData_afterIndex() {
    let lookupWorld      = MarkerLookup(marker: "World".asciiData)
    let lookupHello      = MarkerLookup(marker: "Hello".asciiData)
    let lookupSmallHello = MarkerLookup(marker: "hello".asciiData)

    XCTAssertEqual(6, lookupWorld.firstOccurrenceIn("Hello World".asciiData, after: 3))
    XCTAssertNil(lookupWorld.firstOccurrenceIn("Hello world".asciiData, after: 3))
    XCTAssertEqual(6, lookupWorld.firstOccurrenceIn("Hello World SOME World".asciiData, after: 2))
    XCTAssertEqual(17, lookupWorld.firstOccurrenceIn("Hello world SOME World".asciiData, after: 4))
    XCTAssertNil(lookupHello.firstOccurrenceIn("Hello World".asciiData, after: 3))
    XCTAssertNil(lookupSmallHello.firstOccurrenceIn("hello World".asciiData, after: 3))
    XCTAssertNil(lookupHello.firstOccurrenceIn("hello world".asciiData, after: 3))
    XCTAssertNil(lookupHello.firstOccurrenceIn("hello World SOME World".asciiData, after: 3))
    XCTAssertNil(lookupHello.firstOccurrenceIn("hello world SOME World".asciiData, after: 3))
    XCTAssertEqual(6, lookupWorld.firstOccurrenceIn("Hello World Hello World".asciiData, after: 6))
    XCTAssertEqual(18, lookupWorld.firstOccurrenceIn("Hello World Hello World".asciiData, after: 7))
  }


  func testLastIndex_ofData() {
    let lookupWorld = MarkerLookup(marker: "World".asciiData)
    let lookupHello = MarkerLookup(marker: "Hello".asciiData)
    XCTAssertEqual(6, lookupWorld.lastOccurrenceIn("Hello World".asciiData))
    XCTAssertEqual(18, lookupWorld.lastOccurrenceIn("Hello World Hello World".asciiData))
    XCTAssertNil(lookupWorld.lastOccurrenceIn("Hello world".asciiData))
    XCTAssertNil(lookupWorld.lastOccurrenceIn("Hello world Hello world".asciiData))
    XCTAssertEqual(17, lookupWorld.lastOccurrenceIn("Hello world SOME World".asciiData))
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello world".asciiData))
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello World SOME World".asciiData))
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello world SOME World".asciiData))
    XCTAssertEqual(30, lookupWorld.lastOccurrenceIn("Hello World Hello World Hello World".asciiData))
  }

  func testLastIndex_ofData_afterIndex() {
    let lookupWorld      = MarkerLookup(marker: "World".asciiData)
    let lookupHello      = MarkerLookup(marker: "Hello".asciiData)
    let lookupSmallHello = MarkerLookup(marker: "hello".asciiData)

    XCTAssertEqual(6, lookupWorld.lastOccurrenceIn("Hello World".asciiData, after: 3))
    XCTAssertNil(lookupWorld.lastOccurrenceIn("Hello world".asciiData, after: 3))
    XCTAssertEqual(17, lookupWorld.lastOccurrenceIn("Hello World SOME World".asciiData, after: 6))
    XCTAssertNil(lookupHello.lastOccurrenceIn("Hello World".asciiData, after: 3))
    XCTAssertNil(lookupSmallHello.lastOccurrenceIn("hello World".asciiData, after: 3))
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello world".asciiData, after: 3))
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello World SOME World".asciiData, after: 3))
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello world SOME World".asciiData, after: 3))
    XCTAssertEqual(18, lookupWorld.lastOccurrenceIn("Hello World Hello World".asciiData, after: 7))

    XCTAssertEqual(18, lookupWorld.lastOccurrenceIn("Hello World Hello World".asciiData, after: 10))
    XCTAssertNil(lookupWorld.lastOccurrenceIn("Hello world".asciiData, after: 2))
    XCTAssertNil(lookupWorld.lastOccurrenceIn("Hello world Hello world".asciiData, after: 5))
    XCTAssertEqual(
      40,
      lookupWorld.lastOccurrenceIn("Hello world SOME World Hello world SOME World".asciiData, after: 21)
    )
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello world".asciiData, after: 10))
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello World SOME World".asciiData, after: 10))
    XCTAssertNil(lookupHello.lastOccurrenceIn("hello world SOME World".asciiData, after: 15))
    XCTAssertEqual(30, lookupWorld.lastOccurrenceIn("Hello World Hello World Hello World".asciiData, after: 18))
  }

}

fileprivate extension String {
  var asciiData: Data { get { return self.data(using: .ascii) ?? Data() } }
}