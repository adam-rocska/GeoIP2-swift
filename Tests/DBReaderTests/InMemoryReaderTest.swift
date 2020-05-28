//import Foundation
//import XCTest
//import Index
//@testable import DBReader
//
//class InMemoryReaderTest: XCTestCase {
//
//  func testInit_byFilePath() throws {
//    guard let countryFilePath = bundle.path(
//      forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
//      ofType: "mmdb"
//    ) else { fatalError("GeoLite2 Country DB file was not found.") }
//
//    let reader = try InMemoryReader(fileAtPath: countryFilePath)
//    // TODO : dumb test, but good enough assumption for now
//    XCTAssertEqual(1587472614, reader.metadata.buildEpoch)
//  }
//
//  func testInit_byData() throws {
//    guard let countryFilePath = bundle.path(
//      forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
//      ofType: "mmdb"
//    ) else { fatalError("GeoLite2 Country DB file was not found.") }
//
//    guard let inputStream = InputStream(fileAtPath: countryFilePath) else {
//      fatalError("Couldn't read file.")
//    }
//
//    let reader = try InMemoryReader(data: Data(inputStream: inputStream))
//    // TODO : dumb test, but good enough assumption for now
//    XCTAssertEqual(1587472614, reader.metadata.buildEpoch)
//  }
//
//  func testGet_ipv4() throws {
//    guard let countryFilePath = bundle.path(
//      forResource: "GeoLite2-Country_20200421/GeoLite2-Country",
//      ofType: "mmdb"
//    ) else { fatalError("GeoLite2 Country DB file was not found.") }
//
//    let reader = try InMemoryReader(fileAtPath: countryFilePath)
//    reader.get(IpAddress("80.99.18.166"))
//  }
//
//}
